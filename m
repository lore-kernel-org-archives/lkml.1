Return-Path: <linux-kernel-owner+w=401wt.eu-S1761545AbYHDG4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761545AbYHDG4W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 02:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760096AbYHDG4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 02:56:13 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:48683 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759460AbYHDG4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 02:56:11 -0400
Message-ID: <51970.166.70.238.45.1217831745.squirrel@webmail.wolfmountaingroup.com>
Date: Mon, 4 Aug 2008 00:35:45 -0600 (MDT)
Subject: [PATCH 2.6.27-rc1 13/25] mdb:  Merkey's Kernel Debugger 2.6.27-rc1
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

--- a/debug/mdb-list.c	1969-12-31 17:00:00.000000000 -0700
+++ b/debug/mdb-list.c	2008-08-03 16:15:00.000000000 -0600
@@ -0,0 +1,585 @@
+
+/***************************************************************************
+*
+*   Copyright (c) 2008 Jeff V. Merkey  All Rights Reserved.
+*   1058 East 50 South
+*   Lindon, Utah 84042
+*   jmerkey@wolfmountaingroup.com
+*
+*   This program is free software; you can redistribute it and/or modify it
+*   under the terms of the GNU General Public License as published by the
+*   Free Software Foundation, version 3.
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
+*   jmerkey@wolfmountaingroup.com is the official maintainer of
+*   this code.  You are encouraged to report any bugs, problems, fixes,
+*   suggestions, and comments about this software.
+*
+*   AUTHOR   :  Jeff V. Merkey
+*   FILE     :  MDB-LIST.C
+*   DESCRIP  :  Merkey's NetWare Debugger
+*   DATE     :  April 8, 2008
+*
+***************************************************************************/
+
+#include "mdb.h"
+
+#ifdef CONFIG_MDB
+
+#ifdef MDB_ATOMIC
+static spinlock_t accelLock = SPIN_LOCK_UNLOCKED;
+static long accelflags = 0;
+#endif
+
+ACCELERATOR *accelHead = 0;
+ACCELERATOR *accelTail = 0;
+
+ULONG AccelRoutine(ULONG key, void *p)
+{
+    register ACCELERATOR *accel;
+    ULONG retCode;
+
+    accel = accelHead;
+    while (accel)
+    {
+       if (accel->accelFlags && accel->accelRoutine && accel->key == key)
+       {
+	  retCode = (accel->accelRoutine)(key, p, accel);
+	  return retCode;
+       }
+       accel = accel->accelNext;
+    }
+    return 0;
+}
+
+void ShowDebuggerAccelerators(void)
+{
+   register ACCELERATOR *accel;
+
+   DBGPrint("\nDebugger Keystroke Accelerator(s)\n");
+
+   accel = accelHead;
+   while (accel)
+   {
+      if (accel->shortHelp)
+         if (DBGPrint("%s\n", accel->shortHelp)) return;
+      accel = accel->accelNext;
+   }
+   return;
+}
+
+ULONG IsAccelerator(ULONG key)
+{
+    register ACCELERATOR *accel;
+
+    accel = accelHead;
+    while (accel)
+    {
+       if (accel->accelFlags && accel->accelRoutine && accel->key == key)
+       {
+	  return 1;
+       }
+       accel = accel->accelNext;
+    }
+    return 0;
+}
+
+ULONG AccelHelpRoutine(ULONG key)
+{
+    register ACCELERATOR *accel;
+
+    accel = accelHead;
+    if (key)  // if we were passed a command string
+    {
+       while (accel)
+       {
+	  if (accel->accelFlags && accel->key == key)
+	  {
+	     if (accel->accelRoutineHelp)
+	     {
+		DBGPrint("Accelerator %08X\n", (unsigned)accel->key);
+		(accel->accelRoutineHelp)(key, accel);
+		return 1;
+	     }
+	     DBGPrint("Accelerator %08X\n", (unsigned)accel->key);
+	     return 1;
+	  }
+	  accel = accel->accelNext;
+       }
+       DBGPrint("Help for Accelerator [%08X] not found\n", (unsigned)key);
+       return 1;
+    }
+    else
+    {
+       DBGPrint("Accelerator(s)\n");
+       while (accel)
+       {
+	  if (accel->accelFlags && accel->key && !accel->supervisorCommand)
+	     DBGPrint("%08X         - %s\n",
+                      (unsigned)accel->key, accel->shortHelp);
+	  accel = accel->accelNext;
+       }
+    }
+    return 0;
+}
+
+ACCELERATOR *insertAccel(ACCELERATOR *i, ACCELERATOR *top)
+{
+    ACCELERATOR *old, *p;
+
+    if (!accelTail)
+    {
+       i->accelNext = i->accelPrior = NULL;
+       accelTail = i;
+       return i;
+    }
+    p = top;
+    old = NULL;
+    while (p)
+    {
+       if (p->key < i->key)
+       {
+	  old = p;
+	  p = p->accelNext;
+       }
+       else
+       {
+	  if (p->accelPrior)
+	  {
+	     p->accelPrior->accelNext = i;
+	     i->accelNext = p;
+	     i->accelPrior = p->accelPrior;
+	     p->accelPrior = i;
+	     return top;
+	  }
+	  i->accelNext = p;
+	  i->accelPrior = NULL;
+	  p->accelPrior = i;
+	  return i;
+       }
+    }
+    old->accelNext = i;
+    i->accelNext = NULL;
+    i->accelPrior = old;
+    accelTail = i;
+    return accelHead;
+
+}
+
+ULONG AddAccelRoutine(ACCELERATOR *newAccel)
+{
+    register ACCELERATOR *accel;
+
+#ifdef MDB_ATOMIC
+    spin_lock_irqsave(&accelLock, accelflags);
+#endif
+    accel = accelHead;
+    while (accel)
+    {
+       if (accel == newAccel || accel->key == newAccel->key)
+       {
+#ifdef MDB_ATOMIC
+	  spin_unlock_irqrestore(&accelLock, accelflags);
+#endif
+	  return 1;
+       }
+       accel = accel->accelNext;
+    }
+    newAccel->accelFlags = -1;
+    accelHead = insertAccel(newAccel, accelHead);
+
+#ifdef MDB_ATOMIC
+    spin_unlock_irqrestore(&accelLock, accelflags);
+#endif
+    return 0;
+}
+
+ULONG RemoveAccelRoutine(ACCELERATOR *newAccel)
+{
+    register ACCELERATOR *accel;
+
+#ifdef MDB_ATOMIC
+    spin_lock_irqsave(&accelLock, accelflags);
+#endif
+    accel = accelHead;
+    while (accel)
+    {
+       if (accel == newAccel)   // found, remove from list
+       {
+	  if (accelHead == newAccel)
+	  {
+	     accelHead = (void *) newAccel->accelNext;
+	     if (accelHead)
+		accelHead->accelPrior = NULL;
+	     else
+		accelTail = NULL;
+	  }
+	  else
+	  {
+	     newAccel->accelPrior->accelNext = newAccel->accelNext;
+	     if (newAccel != accelTail)
+		newAccel->accelNext->accelPrior = newAccel->accelPrior;
+	     else
+		accelTail = newAccel->accelPrior;
+	  }
+	  newAccel->accelNext = newAccel->accelPrior = 0;
+	  newAccel->accelFlags = 0;
+
+#ifdef MDB_ATOMIC
+	  spin_unlock_irqrestore(&accelLock, accelflags);
+#endif
+	  return 0;
+       }
+       accel = accel->accelNext;
+    }
+
+#ifdef MDB_ATOMIC
+    spin_unlock_irqrestore(&accelLock, accelflags);
+#endif
+    return -1;
+}
+
+#ifdef MDB_ATOMIC
+static spinlock_t altDebugLock = SPIN_LOCK_UNLOCKED;
+static long altflags = 0;
+#endif
+
+ALT_DEBUGGER *altDebugHead = 0;
+ALT_DEBUGGER *altDebugTail = 0;
+
+int AlternateDebuggerRoutine(int reason, int error, void *frame)
+{
+    register ALT_DEBUGGER *altDebug;
+    register ULONG retCode;
+    unsigned long state;
+
+    state = save_flags();
+    altDebug = altDebugHead;
+    while (altDebug)
+    {
+       if (altDebug->AlternateDebugger)
+       {
+	  retCode = (altDebug->AlternateDebugger)(reason, error, frame);
+	  if (retCode)
+          {
+             restore_flags(state);
+	     return retCode;
+          }
+       }
+       altDebug = altDebug->altDebugNext;
+    }
+    restore_flags(state);
+    return 0;
+}
+
+ULONG AddAlternateDebugger(ALT_DEBUGGER *Debugger)
+{
+    register ALT_DEBUGGER *altDebug;
+
+#ifdef MDB_ATOMIC
+    spin_lock_irqsave(&altDebugLock, altflags);
+#endif
+    altDebug = altDebugHead;
+    while (altDebug)
+    {
+       if (altDebug == Debugger)
+       {
+#ifdef MDB_ATOMIC
+	  spin_unlock_irqrestore(&altDebugLock, altflags);
+#endif
+	  return 1;
+       }
+       altDebug = altDebug->altDebugNext;
+    }
+    if (!altDebugHead)
+    {
+       altDebugHead = Debugger;
+       altDebugTail = Debugger;
+       Debugger->altDebugNext = 0;
+       Debugger->altDebugPrior = 0;
+    }
+    else
+    {
+       altDebugTail->altDebugNext = Debugger;
+       Debugger->altDebugNext = 0;
+       Debugger->altDebugPrior = altDebugTail;
+       altDebugTail = Debugger;
+    }
+
+#ifdef MDB_ATOMIC
+    spin_unlock_irqrestore(&altDebugLock, altflags);
+#endif
+    return 0;
+}
+
+ULONG RemoveAlternateDebugger(ALT_DEBUGGER *Debugger)
+{
+    register ALT_DEBUGGER *altDebug;
+
+#ifdef MDB_ATOMIC
+    spin_lock_irqsave(&altDebugLock, altflags);
+#endif
+    altDebug = altDebugHead;
+    while (altDebug)
+    {
+       if (altDebug == Debugger)   // found, remove from list
+       {
+	  if (altDebugHead == Debugger)
+	  {
+	     altDebugHead = (void *) Debugger->altDebugNext;
+	     if (altDebugHead)
+		altDebugHead->altDebugPrior = NULL;
+	     else
+		altDebugTail = NULL;
+	  }
+	  else
+	  {
+	     Debugger->altDebugPrior->altDebugNext = Debugger->altDebugNext;
+	     if (Debugger != altDebugTail)
+		Debugger->altDebugNext->altDebugPrior = Debugger->altDebugPrior;
+	     else
+		altDebugTail = Debugger->altDebugPrior;
+	  }
+	  Debugger->altDebugNext = Debugger->altDebugPrior = 0;
+
+#ifdef MDB_ATOMIC
+          spin_unlock_irqrestore(&altDebugLock, altflags);
+#endif
+	  return 0;
+       }
+       altDebug = altDebug->altDebugNext;
+    }
+#ifdef MDB_ATOMIC
+    spin_unlock_irqrestore(&altDebugLock, altflags);
+#endif
+    return -1;
+}
+
+#ifdef MDB_ATOMIC
+static spinlock_t debugParserLock = SPIN_LOCK_UNLOCKED;
+static long parserflags = 0;
+#endif
+
+DEBUGGER_PARSER *debugParserHead = 0;
+DEBUGGER_PARSER *debugParserTail = 0;
+
+ULONG DebuggerParserRoutine(BYTE *command, BYTE *commandLine,
+			    StackFrame *stackFrame, ULONG Exception)
+{
+    register DEBUGGER_PARSER *debugParser;
+    register ULONG retCode, valid = 0;
+    register BYTE *p;
+
+    p = commandLine;
+    if (!p)
+       return 0;
+
+    // if a passed string is just whitespace, return error
+    while (*p)
+    {
+       if ((*p != ' ') && (*p != '\n') && (*p != '\r'))
+       {
+          valid = TRUE;
+          break;
+       }
+       p++;
+    }
+    if (!valid)
+       return 0;
+
+    debugParser = debugParserHead;
+    while (debugParser)
+    {
+       if (debugParser->parserFlags && debugParser->DebugCommandParser &&
+	   strlen(debugParser->debugCommandName) == strlen(command) &&
+	   (!strcmp(debugParser->debugCommandName, UpcaseString(command))))
+       {
+	  retCode = (debugParser->DebugCommandParser)(commandLine, stackFrame,
+						      Exception, debugParser);
+	  if (retCode)
+	     return retCode;
+       }
+       debugParser = debugParser->debugNext;
+    }
+    DBGPrint("unknown mdb command -> %s\n", command);
+    return 0;
+}
+
+ULONG DebuggerParserHelpRoutine(BYTE *command, BYTE *commandLine)
+{
+    extern void ShowDebuggerAccelerators(void);
+    register DEBUGGER_PARSER *debugParser;
+
+    debugParser = debugParserHead;
+    if (*command)  // if we were passed a command string
+    {
+       while (debugParser)
+       {
+	  if (debugParser->parserFlags &&
+	      strlen(debugParser->debugCommandName) == strlen(command) &&
+	      !strcmp(debugParser->debugCommandName, UpcaseString(command)))
+	  {
+	     if (debugParser->DebugCommandParserHelp)
+	     {
+		DBGPrint("Help for Command %s\n",
+                         debugParser->debugCommandName);
+		(debugParser->DebugCommandParserHelp)(commandLine, debugParser);
+		return 1;
+	     }
+	     DBGPrint("Help for Command %s\n", debugParser->debugCommandName);
+	     return 1;
+	  }
+	  debugParser = debugParser->debugNext;
+       }
+       DBGPrint("Help for Command [%s] not found\n", command);
+       return 1;
+    }
+    else
+    {
+       DBGPrint("Debugger Command(s)\n");
+       while (debugParser)
+       {
+	  if (debugParser->parserFlags && debugParser->debugCommandName &&
+	      !debugParser->supervisorCommand)
+	     if (DBGPrint("%15s    - %s\n", debugParser->debugCommandName,
+                      debugParser->shortHelp)) return 0;
+	  debugParser = debugParser->debugNext;
+       }
+       ShowDebuggerAccelerators();
+    }
+    return 0;
+}
+
+DEBUGGER_PARSER *insertDebuggerParser(DEBUGGER_PARSER *i, DEBUGGER_PARSER
*top)
+{
+    DEBUGGER_PARSER *old, *p;
+
+    if (!debugParserTail)
+    {
+       i->debugNext = i->debugPrior = NULL;
+       debugParserTail = i;
+       return i;
+    }
+    p = top;
+    old = NULL;
+    while (p)
+    {
+       if (strcmp(p->debugCommandName, i->debugCommandName) < 0)
+       {
+	  old = p;
+	  p = p->debugNext;
+       }
+       else
+       {
+	  if (p->debugPrior)
+	  {
+	     p->debugPrior->debugNext = i;
+	     i->debugNext = p;
+	     i->debugPrior = p->debugPrior;
+	     p->debugPrior = i;
+	     return top;
+	  }
+	  i->debugNext = p;
+	  i->debugPrior = NULL;
+	  p->debugPrior = i;
+	  return i;
+       }
+    }
+    old->debugNext = i;
+    i->debugNext = NULL;
+    i->debugPrior = old;
+    debugParserTail = i;
+    return debugParserHead;
+
+}
+
+ULONG AddDebuggerCommandParser(DEBUGGER_PARSER *parser)
+{
+    register DEBUGGER_PARSER *debugParser;
+
+#ifdef MDB_ATOMIC
+    spin_lock_irqsave(&debugParserLock, parserflags);
+#endif
+    debugParser = debugParserHead;
+    while (debugParser)
+    {
+       if (debugParser == parser ||
+	  (strlen(parser->debugCommandName) ==
strlen(debugParser->debugCommandName) &&
+	  (!strcmp(parser->debugCommandName, debugParser->debugCommandName))))
+       {
+#ifdef MDB_ATOMIC
+	  spin_unlock_irqrestore(&debugParserLock, parserflags);
+#endif
+	  return 1;
+       }
+       debugParser = debugParser->debugNext;
+    }
+    parser->parserFlags = -1;
+    parser->debugCommandNameLength = strlen(parser->debugCommandName);
+
+    debugParserHead = insertDebuggerParser(parser, debugParserHead);
+
+#ifdef MDB_ATOMIC
+    spin_unlock_irqrestore(&debugParserLock, parserflags);
+#endif
+    return 0;
+}
+
+ULONG RemoveDebuggerCommandParser(DEBUGGER_PARSER *parser)
+{
+    register DEBUGGER_PARSER *debugParser;
+
+#ifdef MDB_ATOMIC
+    spin_lock_irqsave(&debugParserLock, parserflags);
+#endif
+    debugParser = debugParserHead;
+    while (debugParser)
+    {
+       if (debugParser == parser)   // found, remove from list
+       {
+	  if (debugParserHead == parser)
+	  {
+	     debugParserHead = (void *) parser->debugNext;
+	     if (debugParserHead)
+		debugParserHead->debugPrior = NULL;
+	     else
+		debugParserTail = NULL;
+	  }
+	  else
+	  {
+	     parser->debugPrior->debugNext = parser->debugNext;
+	     if (parser != debugParserTail)
+		parser->debugNext->debugPrior = parser->debugPrior;
+	     else
+		debugParserTail = parser->debugPrior;
+	  }
+	  parser->debugNext = parser->debugPrior = 0;
+	  parser->parserFlags = 0;
+
+#ifdef MDB_ATOMIC
+	  spin_unlock_irqrestore(&debugParserLock, parserflags);
+#endif
+	  return 0;
+       }
+       debugParser = debugParser->debugNext;
+    }
+#ifdef MDB_ATOMIC
+    spin_unlock_irqrestore(&debugParserLock, parserflags);
+#endif
+    return -1;
+}
+
+#endif
+


By making a contribution to this project, I certify that
the contribution was created in whole or in part by me and I
have the right to submit it under the open source license
indicated in the file.

Jeffrey Vernon Merkey



