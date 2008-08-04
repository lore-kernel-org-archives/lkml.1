Return-Path: <linux-kernel-owner+w=401wt.eu-S1761221AbYHDGvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761221AbYHDGvm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 02:51:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756186AbYHDGvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 02:51:33 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:48543 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756021AbYHDGvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 02:51:32 -0400
Message-ID: <37445.166.70.238.45.1217831466.squirrel@webmail.wolfmountaingroup.com>
Date: Mon, 4 Aug 2008 00:31:06 -0600 (MDT)
Subject: [PATCH 2.6.27-rc1 6/25] mdb:  Merkey's Kernel Debugger 2.6.27-rc1
From: jmerkey@wolfmountaingroup.com
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Netware style debugger for Linux written by Jeffrey Vernon Merkey

--- a/debug/mdb.c	1969-12-31 17:00:00.000000000 -0700
+++ b/debug/mdb.c	2008-08-03 16:15:00.000000000 -0600
@@ -0,0 +1,496 @@
+
+/***************************************************************************
+*
+*   Copyright (c) 1997, 2008 Jeff V. Merkey  All Rights Reserved.
+*   1058 East 50 South
+*   Lindon, Utah  84042
+*   jmerkey@wolfmountaingroup.com
+*
+*   This program is free software; you can redistribute it and/or modify it
+*   under the terms of the GNU General Public License as published by the
+*   Free Software Foundation, version 2, or any later version.
+*
+*   This program is distributed in the hope that it will be useful, but
+*   WITHOUT ANY WARRANTY; without even the implied warranty of
+*   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+*   General Public License for more details.
+*
+*   You are free to modify and re-distribute this program in accordance
+*   with the terms specified in the GNU Public License.  The copyright
+*   contained in this code is required to be present in any derivative
+*   works and you are required to provide the source code for this
+*   program as part of any commercial or non-commercial distribution.
+*   You are required to respect the rights of the Copyright holders
+*   named within this code.
+*
+*   jmerkey@utah-nac.org is the official maintainer of
+*   this code.  You are encouraged to report any bugs, problems, fixes,
+*   suggestions, and comments about this software to jmerkey@utah-nac.org
+*   or linux-kernel@vger.kernel.org.  New releases, patches, bug fixes, and
+*   technical documentation can be found at www.kernel.org.  I will
+*   periodically post new releases of this software to www.kernel.org
+*   that contain bug fixes and enhanced capabilities.
+*
+*
+*   AUTHOR   :  Jeff V. Merkey
+*   FILE     :  MDB.C
+*   DESCRIP  :  Merkey's NetWare Debugger
+*   DATE     :  December 20, 2001
+*
+***************************************************************************/
+
+#include "mdb.h"
+
+#ifdef CONFIG_MDB
+
+extern void MDBInitializeDebugger(void);
+extern void MDBClearDebuggerState(void);
+
+ULONG TotalSystemMemory = 0;
+ULONG HistoryPointer = 0;
+BYTE HistoryBuffer[16][256]; // remember last 32 non-repeating commands
+BYTE delim_table[256];
+void set_delimiter(BYTE c) {  delim_table[c & 0xFF] = TRUE;  }
+
+void SaveLastCommandInfo(ULONG processor)
+{
+    register int i;
+
+    repeatCommand = 0;
+    lastCommand = toupper(debugCommand[0]);
+    lastDisplayLength = displayLength;
+    ProcessorMode[processor] = 0;
+
+    for (i=0; (i < 80) && (debugCommand[i]); i++)
+    {
+       if ((debugCommand[i] == '\n') || (debugCommand[i] == '\r'))
+          lastDebugCommand[i] = '\0';
+       else
+          lastDebugCommand[i] = debugCommand[i];
+    }
+    lastDebugCommand[i] = '\0';
+
+    return;
+}
+
+StackFrame CurrentStackFrame[MAX_PROCESSORS];
+
+atomic_t inmdb = { 0 };
+BYTE *mdb_oops = NULL;
+BYTE *last_mdb_oops = NULL;
+
+int mdb(int reason, int error, void *frame)
+{
+    register ULONG retCode = 0, processor = get_processor_id();
+    extern void ReadStackFrame(void *, StackFrame *, ULONG);
+    extern void WriteStackFrame(void *, StackFrame *, ULONG);
+    unsigned long state;
+#ifdef CONFIG_MDB_CONSOLE_REDIRECTION
+    extern int kmsg_redirect;
+    int kmsg_redirect_save;
+#endif
+
+    preempt_disable();
+#ifdef CONFIG_MDB_CONSOLE_REDIRECTION
+    kmsg_redirect_save = kmsg_redirect;
+    kmsg_redirect = 0;
+#endif
+
+    last_mdb_oops = NULL;
+    if (mdb_oops)
+    {
+       last_mdb_oops = mdb_oops;
+       mdb_oops = NULL;
+    }
+    atomic_inc(&inmdb);
+    state = save_flags();
+    memset(&CurrentStackFrame[processor], 0, sizeof(StackFrame));
+    ReadStackFrame(frame, &CurrentStackFrame[processor], processor);
+    CurrentStackFrame[processor].tReserved[2] = (ULONG)frame;
+    retCode = debugger_entry(reason, &CurrentStackFrame[processor],
+                             processor);
+    WriteStackFrame(frame, &CurrentStackFrame[processor], processor);
+
+    restore_flags(state);
+    atomic_dec(&inmdb);
+
+#ifdef CONFIG_MDB_CONSOLE_REDIRECTION
+    kmsg_redirect = kmsg_redirect_save;
+#endif
+    preempt_enable();
+
+    return retCode;
+}
+
+int mdb_close(void) {  MDBClearDebuggerState(); return 0; }
+
+ALT_DEBUGGER MDBDebugger = { NULL, NULL, NULL };
+
+int mdb_init(void)
+{
+   register int i;
+
+   MDBInitializeDebugger();
+   MDBDebugger.AlternateDebugger = mdb;
+   AddAlternateDebugger(&MDBDebugger);
+
+   // initialize delimiter lookup table
+   for (i=0; i < 256; i++)
+      delim_table[i] = '\0';
+
+   set_delimiter('\0');
+   set_delimiter('\n');
+   set_delimiter('\r');
+   set_delimiter('[');
+   set_delimiter(']');
+   set_delimiter('<');
+   set_delimiter('>');
+   set_delimiter('(');
+   set_delimiter(')');
+   set_delimiter('|');
+   set_delimiter('&');
+   set_delimiter('=');
+   set_delimiter('*');
+   set_delimiter('+');
+   set_delimiter('-');
+   set_delimiter('/');
+   set_delimiter('%');
+   set_delimiter('~');
+   set_delimiter('^');
+   set_delimiter('!');
+   set_delimiter(' ');
+
+   return 0;
+}
+
+ULONG ScreenInputFromKeyboard(BYTE *buf, ULONG buf_index, ULONG max_index)
+{
+    register ULONG key;
+    register BYTE *p;
+    register int i, r, temp;
+    register ULONG orig_index, HistoryIndex;
+    extern ULONG IsAccelerator(ULONG);
+
+    if (buf_index > max_index)
+       return 0;
+
+    if (!max_index)
+       return 0;
+
+    orig_index = buf_index;
+
+    p = (BYTE *)((ULONG)buf + (ULONG)buf_index);
+    for (i=0; i < (max_index - buf_index); i++)
+       *p++ = '\0';
+
+    HistoryIndex = HistoryPointer;
+    while (1)
+    {
+       key = mdb_getkey();
+
+       if ((IsAccelerator(key)) && (key != 13))
+	  return key;
+
+       switch (key)
+       {
+	  case 8: // backspace
+	     if (buf_index)
+	     {
+                register int delta;
+
+		buf_index--;
+		DBGPrint("\b \b");
+
+//		if (!buf[buf_index + 1])
+//		   buf[buf_index] = '\0';
+//		else
+//		   buf[buf_index] = ' ';
+
+                delta = strlen(buf) - buf_index;
+
+                for (i=0; i < delta; i++)
+                  DBGPrint(" ");
+
+                for (i=0; i < delta; i++)
+                   DBGPrint("\b");
+
+	        p = (BYTE *) &buf[buf_index];
+	        temp = buf_index;
+	        p++;
+	        while ((*p) && (temp < max_index))
+		   buf[temp++] = *p++;
+	        buf[temp] = '\0';
+
+                delta = strlen(buf) - buf_index;
+
+                for (i=0; (i < delta) && (buf[i]); i++)
+                  DBGPrint("%c", buf[buf_index + i]);
+
+                for (i=0; i < delta; i++)
+                   DBGPrint("\b");
+	     }
+	     break;
+
+	  case K_P7: // home
+             {
+                BYTE s[256];
+
+                for (i=0; (i < buf_index) && (i < 255); i++)
+                   s[i] = '\b';
+                s[i] = '\0';
+                DBGPrint("%s", s);
+
+	        buf_index = orig_index;
+             }
+	     break;
+
+	  case K_P1: // end
+             {
+                BYTE s[256];
+
+                for (i=0; (i < buf_index) && (i < 255); i++)
+                   s[i] = '\b';
+                s[i] = '\0';
+                DBGPrint("%s", s);
+
+                for (i=0; (i < strlen(buf)) && (i < 255); i++)
+                   DBGPrint("%c", buf[i]);
+
+	        buf_index = strlen(buf);
+
+             }
+	     break;
+
+	  case K_P4: // left arrow
+	     if (buf_index)
+	     {
+		buf_index--;
+		DBGPrint("\b");
+	     }
+	     break;
+
+	  case K_P6: // right arrow
+	     if (buf_index < strlen(buf))
+	     {
+                DBGPrint("%c", buf[buf_index]);
+		buf_index++;
+	     }
+	     break;
+
+	  case K_PDOT:
+             {
+                register int delta;
+
+                delta = strlen(buf) - buf_index;
+
+                for (i=0; i < delta; i++)
+                  DBGPrint(" ");
+
+                for (i=0; i < delta; i++)
+                   DBGPrint("\b");
+
+	        p = (BYTE *) &buf[buf_index];
+	        temp = buf_index;
+	        p++;
+	        while ((*p) && (temp < max_index))
+		   buf[temp++] = *p++;
+	        buf[temp] = '\0';
+
+                delta = strlen(buf) - buf_index;
+
+                for (i=0; (i < delta) && (buf[i]); i++)
+                  DBGPrint("%c", buf[buf_index + i]);
+
+                for (i=0; i < delta; i++)
+                   DBGPrint("\b");
+             }
+	     break;
+
+	  case 13:  // enter
+	     if (strncmp(HistoryBuffer[(HistoryPointer - 1) & 0xF], buf,
+                         strlen(buf)) || (strlen(buf) !=
+                         strlen(HistoryBuffer[(HistoryPointer - 1) & 0xF])))
+	     {
+		for (r=0; r < max_index; r++)
+		{
+		   if (buf[0])
+		      HistoryBuffer[HistoryPointer & 0xF][r] = buf[r];
+		}
+		if (buf[0])
+		   HistoryPointer++;
+	     }
+	     return 13;
+
+	  case K_P8: // up arrow
+	     if (HistoryBuffer[(HistoryIndex - 1) & 0xF][0])
+	     {
+                BYTE s[256];
+
+                for (i=0; (i < buf_index) && (i < 255); i++)
+                   s[i] = '\b';
+                s[i] = '\0';
+                DBGPrint("%s", s);
+
+                for (i=0; (i < strlen(buf)) && (i < 255); i++)
+                   s[i] = ' ';
+                s[i] = '\0';
+                DBGPrint("%s", s);
+
+                for (i=0; (i < strlen(buf)) && (i < 255); i++)
+                   s[i] = '\b';
+                s[i] = '\0';
+                DBGPrint("%s", s);
+
+		HistoryIndex--;
+
+		for (r=0; r < max_index; r++)
+		   buf[r] = HistoryBuffer[HistoryIndex & 0xF][r];
+		buf_index = strlen(buf);
+
+                DBGPrint("%s", buf);
+	     }
+	     break;
+
+	  case K_P2: // down arrow
+	     if (HistoryBuffer[HistoryIndex & 0xF][0])
+	     {
+                BYTE s[256];
+
+                for (i=0; (i < buf_index) && (i < 255); i++)
+                   s[i] = '\b';
+                s[i] = '\0';
+                DBGPrint("%s", s);
+
+                for (i=0; (i < strlen(buf)) && (i < 255); i++)
+                   s[i] = ' ';
+                s[i] = '\0';
+                DBGPrint("%s", s);
+
+                for (i=0; (i < strlen(buf)) && (i < 255); i++)
+                   s[i] = '\b';
+                s[i] = '\0';
+                DBGPrint("%s", s);
+
+		HistoryIndex++;
+
+		for (r=0; r < max_index; r++)
+		   buf[r] = HistoryBuffer[HistoryIndex & 0xF][r];
+		buf_index = strlen(buf);
+
+                DBGPrint("%s", buf);
+	     }
+	     break;
+
+	  default:
+	     if ((key > 0x7E) || (key < ' '))  // if above or below text
+		break;
+	     else
+	     {
+	        if (strlen(buf) < max_index)
+		{
+                   register int delta;
+
+		   for (i=max_index; i > buf_index; i--)
+		      buf[i] = buf[i-1];
+		   buf[buf_index] = (BYTE)key;
+		   if (buf_index < max_index)
+		      buf_index++;
+
+                   delta = strlen(buf) - buf_index;
+
+                   for (i=0; (i < delta) && (buf[i]); i++)
+                        DBGPrint("%c", buf[buf_index + i]);
+
+                   for (i=0; i < delta; i++)
+                        DBGPrint("\b");
+		}
+             }
+	     break;
+       }
+    }
+}
+
+ULONG debugger_command_entry(ULONG processor, ULONG Exception,
+			    StackFrame *stackFrame)
+{
+    BYTE verbBuffer[100];
+    register BYTE *verb, *pp, *vp;
+    register ULONG count, retCode, key;
+    extern ULONG reason_toggle;
+    extern void displayRegisters(StackFrame *, ULONG);
+
+    if (Exception > 22)
+       Exception = 20;
+
+    lastUnasmAddress = (ULONG) GetIP(stackFrame);
+    lastLinkAddress = lastDumpAddress = (BYTE *)
GetStackAddress(stackFrame);
+    lastDisplayLength = displayLength = 20;
+    lastCommandEntry = lastCommand;
+
+    if (reason_toggle)
+    {
+       if (!ConsoleDisplayBreakReason(stackFrame, Exception, processor,
+                                      lastCommand))
+          return 0;
+    }
+    displayRegisters(stackFrame, processor);
+    nextUnasmAddress = disassemble(stackFrame, lastUnasmAddress, 1, 1);
+    ClearTempBreakpoints();
+
+    while (1)
+    {
+       extern int nextline;
+
+       nextline = 0;
+
+       DBGPrint("(%i)> ", (int)processor);
+
+       SaveLastCommandInfo(processor);
+
+       key = ScreenInputFromKeyboard((BYTE *)&debugCommand[0], 0, 80);
+       if (key)
+       {
+          extern ULONG AccelRoutine(ULONG key, void *p);
+
+          retCode = AccelRoutine(key, stackFrame);
+          switch (retCode)
+          {
+             case 0:
+                break;
+
+             case -1:
+   	        return retCode;
+
+             default:
+                DBGPrint("\n");
+                continue;
+          }
+       }
+
+       if (*debugCommand)
+       {
+          count = 0;
+          pp = (BYTE *)debugCommand;
+          vp = verb = &verbBuffer[0];
+          while (*pp && *pp == ' ' && count++ < 80)
+    	     pp++;
+
+          while (*pp && *pp != ' ' && *pp != '=' && count++ < 80)
+  	     *vp++ = *pp++;
+          *vp = '\0';
+
+          while (*pp && *pp == ' ' && count++ < 80)
+  	     pp++;
+
+          retCode = DebuggerParserRoutine(verb, (BYTE *)debugCommand,
+                                          stackFrame, Exception);
+          switch (retCode)
+          {
+             case -1:
+  	       return retCode;
+          }
+       }
+    }
+}
+
+#endif


By making a contribution to this project, I certify that
the contribution was created in whole or in part by me and I
have the right to submit it under the open source license
indicated in the file.

Jeffrey Vernon Merkey



