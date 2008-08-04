Return-Path: <linux-kernel-owner+w=401wt.eu-S1760500AbYHDCbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760500AbYHDCbb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 22:31:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754569AbYHDCbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 22:31:15 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:45157 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755547AbYHDCbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 22:31:08 -0400
Message-ID: <57474.166.70.238.45.1217815846.squirrel@webmail.wolfmountaingroup.com>
Date: Sun, 3 Aug 2008 20:10:46 -0600 (MDT)
Subject: [PATCH 2.6.26 4/25] mdb: Merkey's Kernel Debugger
From: jmerkey@wolfmountaingroup.com
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
References: 
In-Reply-To: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Netware Style Debugger for Linux written by Jeffrey Vernon Merkey

--- linux-2.6.26/debug/mdb-base.c	1969-12-31 17:00:00.000000000 -0700 +++
linux-2.6.26-mdb/debug/mdb-base.c	2008-08-03 12:49:01.000000000 -0600 @@
-0,0 +1,2432 @@
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
+*   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU +* 
 General Public License for more details.
+*
+*   You are free to modify and re-distribute this program in accordance
+*   with the terms specified in the GNU Public License.  The copyright +*
  contained in this code is required to be present in any derivative +*  
works and you are required to provide the source code for this +*  
program as part of any commercial or non-commercial distribution. +*   You
are required to respect the rights of the Copyright holders +*   named
within this code.
+*
+*   jmerkey@wolfmountaingroup.com is the official maintainer of
+*   this code.  You are encouraged to report any bugs, problems, fixes,
+*   suggestions, and comments about this software.
+*
+*   AUTHOR   :  Jeff V. Merkey
+*   FILE     :  MDB-BASE.C
+*   DESCRIP  :  Merkey's NetWare Debugger
+*   DATE     :  April 8, 2008
+*
+***************************************************************************/
+
+#include "mdb.h"
+
+#ifdef CONFIG_MDB
+
+ULONG debug_deref = 0;
+ULONG full_deref_toggle = 0;
+ULONG general_toggle = TRUE;
+ULONG line_info_toggle = TRUE;
+ULONG control_toggle = 0;
+ULONG segment_toggle = TRUE;
+ULONG numeric_toggle = 0;
+ULONG reason_toggle = TRUE;
+
+ULONG enterKeyACC(ULONG key, void *stackFrame,
+  	          ACCELERATOR *accel)
+{
+    BYTE *verbBuffer = &workbuf[0][0];
+    register BYTE *verb, *pp, *vp;
+    register ULONG count;
+
+    if (key) {};
+    if (stackFrame) {};
+    if (accel) {};
+
+    if (!debugCommand[0])
+    {
+       count = 0;
+       pp = (BYTE *)lastDebugCommand;
+       vp = verb = &verbBuffer[0];
+       while (*pp && *pp == ' ' && count++ < 80)
+	  pp++;
+
+       while (*pp && *pp != ' ' && count++ < 80)
+	  *vp++ = *pp++;
+       *vp = '\0';
+
+       while (*pp && *pp == ' ' && count++ < 80)
+	  pp++;
+
+       UpcaseString(verb);
+       if (!strcmp(verb, "P") || (lastCommand == K_F8))
+	  strcpy((char *)debugCommand, "P");
+       else
+       if (!strcmp(verb, "T") || (lastCommand == K_F7))
+	  strcpy((char *)debugCommand, "T");
+       else
+       if (!strcmp(verb, "W")   || !strcmp(verb, "D")   ||
+	   !strcmp(verb, "DB")  || !strcmp(verb, "DW")  ||
+	   !strcmp(verb, "DD")  || !strcmp(verb, "DDS") ||
+	   !strcmp(verb, "DS")  || !strcmp(verb, "DL")  ||
+	   !strcmp(verb, "U")   || !strcmp(verb, "UU")  ||
+	   !strcmp(verb, "S")   || !strcmp(verb, "SS")  ||
+	   !strcmp(verb, "SSB") || !strcmp(verb, "ID"))
+       {
+	  strcpy((char *)debugCommand, verb);
+	  repeatCommand = TRUE;
+       }
+    }
+    return 0;
+
+}
+
+
+ULONG displayDebuggerHelpHelp(BYTE *commandLine, DEBUGGER_PARSER *parser) +{
+    if (commandLine) {}
+    if (parser) {}
+
+    DBGPrint("displays general help for all commands, or help for a
specific command\n");
+    DBGPrint("HELP         <enter>  - list all commands\n");
+    DBGPrint("HELP command <enter>  - help for a specific command\n"); +
+    return TRUE;
+}
+
+ULONG displayDebuggerHelp(BYTE *commandLine,
+			 StackFrame *stackFrame, ULONG Exception,
+			 DEBUGGER_PARSER *parser)
+{
+
+    register ULONG count;
+    BYTE *verbBuffer = &workbuf[0][0];
+    register BYTE *verb, *pp, *vp;
+
+    if (stackFrame) {};
+    if (Exception) {};
+
+    commandLine = &commandLine[parser->debugCommandNameLength];
+    while (*commandLine && *commandLine == ' ') commandLine++;
+
+    count = 0;
+    pp = commandLine;
+    vp = verb = &verbBuffer[0];
+    while (*pp && *pp == ' ' && count++ < 80)
+       pp++;
+
+    while (*pp && *pp != ' ' && count++ < 80)
+       *vp++ = *pp++;
+    *vp = '\0';
+
+    while (*pp && *pp == ' ' && count++ < 80)
+       pp++;
+
+    DebuggerParserHelpRoutine(verb, commandLine);
+    return TRUE;
+
+}
+
+// BT, BTA, BTP
+
+extern int bt_stack(struct task_struct *task, struct pt_regs *regs, +	   
        unsigned long *stack);
+
+ULONG backTraceHelp(BYTE *commandLine, DEBUGGER_PARSER *parser)
+{
+    if (commandLine) {}
+    if (parser) {}
+
+    DBGPrint("bt <addr>                - display stack backtrace\n"); +  
 DBGPrint("bta                      - display stack backtrace all
pids\n");
+    DBGPrint("btp <pid>                - display stack backtrace by pid\n");
+    return TRUE;
+}
+
+ULONG backTraceAllPID(BYTE *cmd, StackFrame *stackFrame, ULONG Exception,
+	          DEBUGGER_PARSER *parser)
+{
+    struct task_struct *p, *g;
+
+    if (cmd) {};
+    if (stackFrame) {};
+    if (Exception) {};
+    if (parser) {};
+
+    cmd = &cmd[parser->debugCommandNameLength];
+    while (*cmd && *cmd == ' ') cmd++;
+
+    do_each_thread(g, p)
+    {
+       if (p)
+       {
+          DBGPrint("Stack backtrace for pid %d\n", p->pid);
+          if (bt_stack(p, NULL, NULL))
+             return TRUE;
+       }
+    } while_each_thread(g, p);
+    return TRUE;
+}
+
+ULONG backTracePID(BYTE *cmd, StackFrame *stackFrame, ULONG Exception, +	
         DEBUGGER_PARSER *parser)
+{
+    int pid;
+    ULONG valid = 0;
+    struct task_struct *p, *g;
+
+    if (cmd) {};
+    if (stackFrame) {};
+    if (Exception) {};
+    if (parser) {};
+
+    cmd = &cmd[parser->debugCommandNameLength];
+    while (*cmd && *cmd == ' ') cmd++;
+
+    pid = EvaluateNumericExpression(stackFrame, &cmd, &valid);
+    if (valid)
+    {
+       do_each_thread(g, p)
+       {
+          if (p && (p->pid == pid))
+          {
+             DBGPrint("Stack backtrace for pid %d\n", p->pid);
+             bt_stack(p, NULL, NULL);
+             return TRUE;
+          }
+       } while_each_thread(g, p);
+       DBGPrint("No process with pid %d found\n", pid);
+    }
+    else
+       DBGPrint("invalid pid entered for backtrace\n");
+
+    return TRUE;
+
+}
+
+ULONG backTraceStack(BYTE *cmd, StackFrame *stackFrame, ULONG Exception,
+	             DEBUGGER_PARSER *parser)
+{
+    ULONG valid = 0, address;
+
+    if (cmd) {};
+    if (stackFrame) {};
+    if (Exception) {};
+    if (parser) {};
+
+    cmd = &cmd[parser->debugCommandNameLength];
+    while (*cmd && *cmd == ' ') cmd++;
+
+    address = EvaluateExpression(stackFrame, &cmd, &valid);
+    if (valid)
+    {
+       DBGPrint("Stack backtrace for address 0x%08X\n",
(unsigned)address);
+       bt_stack(NULL, NULL, (unsigned long *)address);
+       return TRUE;
+    }
+    else
+    {
+       DBGPrint("Stack backtrace for address 0x%08X\n",
+                (unsigned)GetStackAddress(stackFrame));
+       bt_stack(NULL, NULL, (unsigned long
*)GetStackAddress(stackFrame));
+       return TRUE;
+    }
+    return TRUE;
+}
+
+void DisplayASCIITable(void)
+{
+
+    register ULONG i;
+    union bhex
+    {
+       unsigned int i;
+       struct btemp {
+	     unsigned one : 1;
+	     unsigned two : 1;
+	     unsigned three : 1;
+	     unsigned four : 1;
+	     unsigned five : 1;
+	     unsigned six : 1;
+	     unsigned seven : 1;
+	     unsigned eight : 1;
+       } b;
+    } val;
+
+    DBGPrint("ASCII Table\n");
+    for (i=0; i < 256; i++)
+    {
+       val.i = i;
+       switch (i)
+       {
+
+	  case 0:
+	     if (DBGPrint("|  %3i  |  (0x%02X)  |  (%1i%1i%1i%1i%1i%1i%1i%1ib) 
| NULL  |", (int)i, (unsigned)i,
+		(int)val.b.eight, (int)val.b.seven, (int)val.b.six,
+                (int)val.b.five,  (int)val.b.four, (int)val.b.three,  +  
             (int)val.b.two, (int)val.b.one)) return;
+	     break;
+
+	  case 8:
+	     if (DBGPrint("|  %3i  |  (0x%02X)  |  (%1i%1i%1i%1i%1i%1i%1i%1ib) 
| BKSP  |", (int)i, (unsigned)i,
+		(int)val.b.eight, (int)val.b.seven, (int)val.b.six,
+                (int)val.b.five,  (int)val.b.four,  (int)val.b.three,  + 
              (int)val.b.two, (int)val.b.one)) return;
+	     break;
+
+	  case 9:
+	     if (DBGPrint("|  %3i  |  (0x%02X)  |  (%1i%1i%1i%1i%1i%1i%1i%1ib) 
| TAB   |", (int)i, (unsigned)i,
+		(int)val.b.eight, (int)val.b.seven, (int)val.b.six,
+                (int)val.b.five,  (int)val.b.four,  (int)val.b.three,  + 
              (int)val.b.two, (int)val.b.one)) return;
+	     break;
+
+	  case 10:
+	     if (DBGPrint("|  %3i  |  (0x%02X)  |  (%1i%1i%1i%1i%1i%1i%1i%1ib) 
| <CR>  |", (int)i, (unsigned)i,
+		(int)val.b.eight, (int)val.b.seven, (int)val.b.six,
+                (int)val.b.five,  (int)val.b.four,  (int)val.b.three,  + 
              (int)val.b.two, (int)val.b.one)) return;
+	     break;
+
+	  case 13:
+	     if (DBGPrint("|  %3i  |  (0x%02X)  |  (%1i%1i%1i%1i%1i%1i%1i%1ib) 
| <LF>  |", (int)i, (unsigned)i,
+		(int)val.b.eight, (int)val.b.seven, (int)val.b.six,
+                (int)val.b.five,  (int)val.b.four,  (int)val.b.three,  + 
              (int)val.b.two, (int)val.b.one)) return;
+	     break;
+
+	  case 32:
+	     if (DBGPrint("|  %3i  |  (0x%02X)  |  (%1i%1i%1i%1i%1i%1i%1i%1ib) 
| SPACE |", (int)i, (unsigned)i,
+	        (int)val.b.eight, (int)val.b.seven, (int)val.b.six,
+                (int)val.b.five,  (int)val.b.four,  (int)val.b.three,  + 
              (int)val.b.two, (int)val.b.one)) return;
+	     break;
+
+	  default:
+	     if (DBGPrint("|  %3i  |  (0x%02X)  |  (%1i%1i%1i%1i%1i%1i%1i%1ib) 
|  %c    |", (int)i, (unsigned)i,
+	        (int)val.b.eight, (int)val.b.seven, (int)val.b.six,
+                (int)val.b.five,  (int)val.b.four,  (int)val.b.three,  + 
              (int)val.b.two, (int)val.b.one, (BYTE) i)) return; +	    
break;
+
+       }
+       if (DBGPrint("\n")) return;
+    }
+
+}
+
+#if defined(CONFIG_MODULES)
+
+// LSMOD, .M
+
+ULONG listModulesHelp(BYTE *commandLine, DEBUGGER_PARSER *parser) +{
+    if (commandLine) {}
+    if (parser) {}
+
+    DBGPrint(".M                       - list loaded modules\n"); +   
DBGPrint("lsmod                    - list loaded modules\n"); +   
DBGPrint("rmmod <name>             - unload module\n");
+    return TRUE;
+}
+
+ULONG listModules(BYTE *cmd, StackFrame *stackFrame, ULONG Exception, +	 
        DEBUGGER_PARSER *parser)
+{
+    if (cmd) {};
+    if (stackFrame) {};
+    if (Exception) {};
+    if (parser) {};
+
+    cmd = &cmd[parser->debugCommandNameLength];
+    while (*cmd && *cmd == ' ') cmd++;
+
+    if (*cmd)
+       mdb_modules(cmd, DBGPrint);
+    else
+       mdb_modules(NULL, DBGPrint);
+    return TRUE;
+}
+
+ULONG unloadModule(BYTE *cmd, StackFrame *stackFrame, ULONG Exception, +	
          DEBUGGER_PARSER *parser)
+{
+    if (cmd) {};
+    if (stackFrame) {};
+    if (Exception) {};
+    if (parser) {};
+
+    cmd = &cmd[parser->debugCommandNameLength];
+    while (*cmd && *cmd == ' ') cmd++;
+
+    DBGPrint("Module unload unsupported in this version\n");
+    return 0;
+}
+
+#endif
+
+// REBOOT
+
+ULONG rebootSystemHelp(BYTE *commandLine, DEBUGGER_PARSER *parser) +{
+    if (commandLine) {}
+    if (parser) {}
+
+    DBGPrint("reboot                   - reboot host system\n");
+    return TRUE;
+}
+
+
+ULONG rebootSystem(BYTE *cmd, StackFrame *stackFrame, ULONG Exception, +	
    DEBUGGER_PARSER *parser)
+{
+    extern void machine_restart(int);
+
+    if (cmd) {};
+    if (stackFrame) {};
+    if (Exception) {};
+    if (parser) {};
+
+    machine_restart(0);
+    return TRUE;
+}
+
+// SECTIONS, .S
+
+ULONG displaySectionsHelp(BYTE *commandLine, DEBUGGER_PARSER *parser) +{
+    if (commandLine) {}
+    if (parser) {}
+
+    DBGPrint("sections                 - display kernel/module
sections\n");
+    DBGPrint(".s                       - display kernel/module
sections\n");
+    return TRUE;
+}
+
+ULONG displaySections(BYTE *cmd,
+		      StackFrame *stackFrame, ULONG Exception,
+		      DEBUGGER_PARSER *parser)
+{
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     DBGPrint("\n");
+
+     return TRUE;
+}
+
+// PS, .P
+
+ULONG displayKernelProcessHelp(BYTE *commandLine, DEBUGGER_PARSER *parser)
+{
+    if (commandLine) {}
+    if (parser) {}
+
+    DBGPrint("ps <addr>                - display kernel processes\n"); + 
  DBGPrint(".p <addr>                - display kernel processes\n"); +   
return TRUE;
+}
+
+ULONG displayKernelProcess(BYTE *cmd,
+		           StackFrame *stackFrame, ULONG Exception,
+		           DEBUGGER_PARSER *parser)
+{
+     struct task_struct *p, *g;
+     ULONG valid = 0;
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     cmd = &cmd[parser->debugCommandNameLength];
+     while (*cmd && *cmd == ' ') cmd++;
+
+     if (*cmd)
+     {
+        p = (struct task_struct *)EvaluateExpression(stackFrame, &cmd,
&valid);
+        if (valid && p)
+        {
+	   DBGPrint("%-*s      Pid   Parent [*] State %-*s Command\n",
+	   	     (int)(2*sizeof(void *))+2, "Task Addr",
+		     (int)(2*sizeof(void *))+2, "Thread");
+
+	   if (DBGPrint("0x%p %8d %8d  %d    %c  0x%p %s\n",
+	       (void *)p, p->pid, p->real_parent->pid,
+	       task_curr(p),
+               (p->state == 0) ? 'R' :
+	       (p->state < 0) ? 'U' :
+	       (p->state & TASK_UNINTERRUPTIBLE) ? 'D' :
+	       (p->state & TASK_STOPPED) ? 'T' :
+	       (p->state & TASK_TRACED) ? 'C' :
+	       (p->exit_state & EXIT_ZOMBIE) ? 'Z' :
+	       (p->exit_state & EXIT_DEAD) ? 'E' :
+	       (p->state & TASK_INTERRUPTIBLE) ? 'S' : '?',
+	       (void *)(&p->thread),
+	        p->comm))
+                  return TRUE;
+            return TRUE;
+        }
+        DBGPrint("invalid task address\n");
+        return TRUE;
+     }
+     else
+     {
+	DBGPrint("%-*s      Pid   Parent [*] State %-*s Command\n",
+		(int)(2*sizeof(void *))+2, "Task Addr",
+		(int)(2*sizeof(void *))+2, "Thread");
+
+        do_each_thread(g, p)
+        {
+           if (p)
+           {
+	      if (DBGPrint("0x%p %8d %8d  %d    %c  0x%p %s\n",
+		   (void *)p, p->pid, p->real_parent->pid,
+		   task_curr(p),
+                   (p->state == 0) ? 'R' :
+		   (p->state < 0) ? 'U' :
+		   (p->state & TASK_UNINTERRUPTIBLE) ? 'D' :
+		   (p->state & TASK_STOPPED) ? 'T' :
+		   (p->state & TASK_TRACED) ? 'C' :
+		   (p->exit_state & EXIT_ZOMBIE) ? 'Z' :
+		   (p->exit_state & EXIT_DEAD) ? 'E' :
+		   (p->state & TASK_INTERRUPTIBLE) ? 'S' : '?',
+		   (void *)(&p->thread),
+		   p->comm))
+                 return TRUE;
+           }
+        } while_each_thread(g, p);
+     }
+     return TRUE;
+
+}
+
+ULONG ascTableHelp(BYTE *commandLine, DEBUGGER_PARSER *parser)
+{
+    if (commandLine) {}
+    if (parser) {}
+
+    DBGPrint("a                        - display ASCII Table\n"); +   
return TRUE;
+}
+
+// A
+
+ULONG displayASCTable(BYTE *cmd,
+		     StackFrame *stackFrame, ULONG Exception,
+		     DEBUGGER_PARSER *parser)
+{
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     DisplayASCIITable();
+     return TRUE;
+
+}
+
+typedef struct _LINE_INFO
+{
+   ULONG SourcePresent;
+   BYTE *SourceLine;
+   BYTE *ModuleName;
+   ULONG LineNumber;
+} LINE_INFO;
+
+void GetLineInfoFromValue(ULONG value, LINE_INFO *lineInfo, ULONG *exact) +{
+    if (exact)
+       *exact = 0;
+
+    if (lineInfo)
+    {
+        lineInfo->SourcePresent = 0;
+        lineInfo->SourceLine = "";
+        lineInfo->ModuleName = "";
+        lineInfo->LineNumber = 0;
+    }
+    return;
+}
+
+ULONG disassemble(StackFrame *stackFrame, ULONG p, ULONG count, ULONG use)
+{
+    register ULONG i;
+    BYTE *symbolName;
+    BYTE *moduleName;
+    ULONG exact = 0;
+    extern ULONG line_info_toggle;
+    LINE_INFO lineInfo;
+    register int c = get_processor_id();
+
+    for (i=0; i < count; i++)
+    {
+       GetLineInfoFromValue(p, &lineInfo, &exact);
+
+       if (line_info_toggle && exact)
+       {
+	  if (lineInfo.SourcePresent && lineInfo.SourceLine)
+	  {
+	     register ULONG length = strlen(lineInfo.SourceLine);
+
+	     i = length > 80
+             ? i + 1 + (length / 80)
+             : i + 1;
+
+	     DBGPrint("%s (%s : line %d)\n",
+				 lineInfo.SourceLine, lineInfo.ModuleName,
+				 lineInfo.LineNumber);
+
+	  }
+	  else if (line_info_toggle && lineInfo.LineNumber)
+	  {
+	     i++;
+	     DBGPrint("file %s  line %d\n",
+				 lineInfo.ModuleName, lineInfo.LineNumber);
+	  }
+       }
+
+       if (i >= count && count != 1)
+	  break;
+
+       symbolName = GetSymbolFromValue(p, &symbuf[c][0], MAX_SYMBOL_LEN);
+       if (symbolName)
+       {
+	  i++;
+          moduleName = GetModuleInfoFromSymbolValue(p, &modbuf[c][0],  + 
                                                  MAX_SYMBOL_LEN); +      
   if (moduleName)
+          {
+	     if (DBGPrint("%s|%s:\n", moduleName, symbolName)) return p; +      
   }
+          else
+          {
+	     if (DBGPrint("%s:\n", symbolName)) return p;
+          }
+       }
+       if (i >= count && count != 1)
+	  break;
+
+       if (unassemble(stackFrame, p, use, &p)) return p;
+    }
+
+    return p;
+
+}
+
+ULONG dumpSearchResults(BYTE *p, ULONG count)
+{
+
+   BYTE *symbolName;
+   BYTE *moduleName;
+   register ULONG i, r, total;
+   BYTE ch;
+   register int c = get_processor_id();
+
+   if (DBGPrint("           0  1  2  3  4  5  6  7  8  9  A  B  C  D  E 
F\n"))
+      return 1;
+
+   for (r=0; r < count; r++)
+   {
+      symbolName = GetSymbolFromValue((ULONG) p, &symbuf[c][0],
MAX_SYMBOL_LEN);
+      if (symbolName)
+      {
+         moduleName = GetModuleInfoFromSymbolValue((ULONG) p,
&modbuf[c][0],
+                                                   MAX_SYMBOL_LEN); +    
    if (moduleName)
+         {
+	    if (DBGPrint("%s|%s:\n", moduleName, symbolName)) return 1;
+         }
+         else
+         {
+	    if (DBGPrint("%s:\n", symbolName)) return 1;
+         }
+	 if (r++ >= count && count != 1)
+	    break;
+      }
+      DBGPrint("%08X ", (unsigned) p);
+      for (total = 0, i=0; i < 16; i++, total++)
+      {
+	 DBGPrint(" %02X", (unsigned) mdb_getword((ULONG)&p[i], 1));
+      }
+      DBGPrint("  ");
+      for (i=0; i < total; i++)
+      {
+         ch = mdb_getword((ULONG)&p[i], 1);
+
+	 if (ch < 32 || ch > 126) DBGPrint(".");
+	 else DBGPrint("%c", ch);
+      }
+      if (DBGPrint("\n")) return 1;
+
+      p = (void *)((ULONG) p + (ULONG) total);
+   }
+   return 0;
+
+}
+
+BYTE *dump(BYTE *p, ULONG count)
+{
+
+   BYTE *symbolName;
+   BYTE *moduleName;
+   register ULONG i, r, total;
+   BYTE ch;
+   register int c = get_processor_id();
+
+   DBGPrint("           0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F\n");
+
+   for (r=0; r < count; r++)
+   {
+      symbolName = GetSymbolFromValue((ULONG) p, &symbuf[c][0],
MAX_SYMBOL_LEN);
+      if (symbolName)
+      {
+         moduleName = GetModuleInfoFromSymbolValue((ULONG) p,
&modbuf[c][0],
+                                                   MAX_SYMBOL_LEN); +    
    if (moduleName)
+	    DBGPrint("%s|%s:\n", moduleName, symbolName);
+         else
+	    DBGPrint("%s:\n", symbolName);
+	 if (r++ >= count && count != 1)
+	    break;
+      }
+      DBGPrint("%08X ", (unsigned) p);
+      for (total = 0, i=0; i < 16; i++, total++)
+      {
+	 DBGPrint(" %02X", (unsigned) mdb_getword((ULONG)&p[i], 1));
+      }
+      DBGPrint("  ");
+      for (i=0; i < total; i++)
+      {
+         ch = mdb_getword((ULONG)&p[i], 1);
+
+	 if (ch < 32 || ch > 126) DBGPrint(".");
+	 else DBGPrint("%c", ch);
+      }
+      DBGPrint("\n");
+
+      p = (void *)((ULONG) p + (ULONG) total);
+   }
+
+   return p;
+
+}
+
+ULONG dumpWordSearchResults(BYTE *p, ULONG count)
+{
+
+   register int i, r;
+   WORD *wp;
+   BYTE *symbolName;
+   BYTE *moduleName;
+   BYTE ch;
+   register int c = get_processor_id();
+
+   wp = (WORD *) p;
+   for (r=0; r < count; r++)
+   {
+      symbolName = GetSymbolFromValue((ULONG) p, &symbuf[c][0],
MAX_SYMBOL_LEN);
+      if (symbolName)
+      {
+         moduleName = GetModuleInfoFromSymbolValue((ULONG) p,
&modbuf[c][0],
+                                                   MAX_SYMBOL_LEN); +    
    if (moduleName)
+         {
+	    if (DBGPrint("%s|%s:\n", moduleName, symbolName)) return 1;
+         }
+         else
+         {
+	    if (DBGPrint("%s:\n", symbolName)) return 1;
+         }
+	 if (r++ >= count && count != 1)
+	    break;
+      }
+      DBGPrint("%08X ", (unsigned) p);
+      for (i=0; i < (16 / 2); i++)
+      {
+	 DBGPrint(" %04X", (unsigned) mdb_getword((ULONG)&wp[i], 2));
+      }
+      DBGPrint("  ");
+      for (i=0; i < 16; i++)
+      {
+         ch = mdb_getword((ULONG)&p[i], 1);
+
+	 if (ch < 32 || ch > 126) DBGPrint(".");
+	 else DBGPrint("%c", ch);
+      }
+      if (DBGPrint("\n")) return 1;
+
+      p = (void *)((ULONG) p + (ULONG) 16);
+      wp = (WORD *) p;
+   }
+
+   return 0;
+
+}
+
+BYTE *dumpWord(BYTE *p, ULONG count)
+{
+
+   register int i, r;
+   WORD *wp;
+   BYTE *symbolName;
+   BYTE *moduleName;
+   BYTE ch;
+   register int c = get_processor_id();
+
+   wp = (WORD *) p;
+   for (r=0; r < count; r++)
+   {
+      symbolName = GetSymbolFromValue((ULONG) p, &symbuf[c][0],
MAX_SYMBOL_LEN);
+      if (symbolName)
+      {
+         moduleName = GetModuleInfoFromSymbolValue((ULONG) p,
&modbuf[c][0],
+                                                   MAX_SYMBOL_LEN); +    
    if (moduleName)
+	    DBGPrint("%s|%s:\n", moduleName, symbolName);
+         else
+	    DBGPrint("%s:\n", symbolName);
+	 if (r++ >= count && count != 1)
+	    break;
+      }
+      DBGPrint("%08X ", (unsigned) p);
+      for (i=0; i < (16 / 2); i++)
+      {
+	 DBGPrint(" %04X", (unsigned) mdb_getword((ULONG)&wp[i], 2));
+      }
+      DBGPrint("  ");
+      for (i=0; i < 16; i++)
+      {
+         ch = mdb_getword((ULONG)&p[i], 1);
+
+	 if (ch < 32 || ch > 126) DBGPrint(".");
+	 else DBGPrint("%c", ch);
+      }
+      DBGPrint("\n");
+
+      p = (void *)((ULONG) p + (ULONG) 16);
+      wp = (WORD *) p;
+   }
+
+   return p;
+
+}
+
+ULONG dumpDoubleSearchResults(BYTE *p, ULONG count)
+{
+
+   register int i, r;
+   ULONG *lp;
+   BYTE *symbolName;
+   BYTE *moduleName;
+   BYTE ch;
+   register int c = get_processor_id();
+
+   lp = (ULONG *) p;
+
+   for (r=0; r < count; r++)
+   {
+      symbolName = GetSymbolFromValue((ULONG) p, &symbuf[c][0],
MAX_SYMBOL_LEN);
+      if (symbolName)
+      {
+         moduleName = GetModuleInfoFromSymbolValue((ULONG) p,
&modbuf[c][0],
+                                                   MAX_SYMBOL_LEN); +    
    if (moduleName)
+         {
+	    if (DBGPrint("%s|%s:\n", moduleName, symbolName)) return 1;
+         }
+         else
+         {
+	    if (DBGPrint("%s:\n", symbolName)) return 1;
+         }
+	 if (r++ >= count && count != 1)
+	    break;
+      }
+      DBGPrint("%08X ", (unsigned) p);
+      for (i=0; i < (16 / 4); i++)
+      {
+	 DBGPrint(" %08X", (unsigned) mdb_getword((ULONG)&lp[i], 4));
+      }
+      DBGPrint("  ");
+      for (i=0; i < 16; i++)
+      {
+         ch = mdb_getword((ULONG)&p[i], 1);
+
+	 if (ch < 32 || ch > 126) DBGPrint(".");
+	 else DBGPrint("%c", ch);
+      }
+      if (DBGPrint("\n")) return 1;
+
+      p = (void *)((ULONG) p + (ULONG) 16);
+      lp = (ULONG *) p;
+   }
+
+   return 0;
+
+}
+
+BYTE *dumpDouble(BYTE *p, ULONG count)
+{
+
+   register int i, r;
+   ULONG *lp;
+   BYTE *symbolName;
+   BYTE *moduleName;
+   BYTE ch;
+   register int c = get_processor_id();
+
+   lp = (ULONG *) p;
+
+   for (r=0; r < count; r++)
+   {
+      symbolName = GetSymbolFromValue((ULONG) p, &symbuf[c][0],
MAX_SYMBOL_LEN);
+      if (symbolName)
+      {
+         moduleName = GetModuleInfoFromSymbolValue((ULONG) p,
&modbuf[c][0],
+                                                   MAX_SYMBOL_LEN); +    
    if (moduleName)
+	    DBGPrint("%s|%s:\n", moduleName, symbolName);
+         else
+	    DBGPrint("%s:\n", symbolName);
+	 if (r++ >= count && count != 1)
+	    break;
+      }
+      DBGPrint("%08X ", (unsigned) p);
+      for (i=0; i < (16 / 4); i++)
+      {
+	 DBGPrint(" %08X", (unsigned) mdb_getword((ULONG)&lp[i], 4));
+      }
+      DBGPrint("  ");
+      for (i=0; i < 16; i++)
+      {
+         ch = mdb_getword((ULONG)&p[i], 1);
+
+	 if (ch < 32 || ch > 126) DBGPrint(".");
+	 else DBGPrint("%c", ch);
+      }
+      DBGPrint("\n");
+
+      p = (void *)((ULONG) p + (ULONG) 16);
+      lp = (ULONG *) p;
+   }
+
+   return p;
+
+}
+
+BYTE *dumpLinkedList(BYTE *p, ULONG count, ULONG offset)
+{
+
+   register int i, r;
+   ULONG *lp;
+   BYTE ch;
+
+   lp = (ULONG *) p;
+
+   DBGPrint("           0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F\n");
+   DBGPrint("Linked List -> [%08X + %X] = %08X\n", (unsigned)lp,  +      
     (unsigned)offset,
+            (unsigned)mdb_getword((ULONG)((ULONG)lp + (ULONG)offset), 4));
+
+   for (r=0; r < count; r++)
+   {
+      DBGPrint("%08X ", (unsigned) p);
+      for (i=0; i < 16; i++)
+      {
+	 DBGPrint(" %02X", (unsigned) mdb_getword((ULONG)&p[i], 1));
+      }
+      DBGPrint("  ");
+      for (i=0; i < 16; i++)
+      {
+         ch = mdb_getword((ULONG)&p[i], 1);
+
+	 if (ch < 32 || ch > 126) DBGPrint(".");
+	 else DBGPrint("%c", ch);
+      }
+      DBGPrint("\n");
+
+      p = (void *)((ULONG) p + (ULONG) 16);
+   }
+
+   return (BYTE *)(mdb_getword((ULONG)((ULONG)lp + (ULONG)offset), 4)); +
+}
+
+BYTE *dumpDoubleStack(StackFrame *stackFrame, BYTE *p, ULONG count) +{
+
+   register int i, r;
+   ULONG *lp;
+   BYTE ch;
+
+   lp = (ULONG *) p;
+
+   DBGPrint("Stack = %04lX:%08X\n",
+            (unsigned long)GetStackSegment(stackFrame),
+            (unsigned)p);
+
+   for (r=0; r < count; r++)
+   {
+      DBGPrint("%04X:", (unsigned) GetStackSegment(stackFrame));
+      DBGPrint("%08X ", (unsigned) p);
+      for (i=0; i < (16 / 4); i++)
+      {
+	 DBGPrint(" %08X", (unsigned) mdb_getword((ULONG)&lp[i], 4));
+      }
+      DBGPrint("  ");
+      for (i=0; i < 16; i++)
+      {
+         ch = mdb_getword((ULONG)&p[i], 1);
+
+	 if (ch < 32 || ch > 126) DBGPrint(".");
+	 else DBGPrint("%c", ch);
+      }
+      DBGPrint("\n");
+
+      p = (void *)((ULONG) p + (ULONG) 16);
+      lp = (ULONG *) p;
+   }
+
+   return p;
+
+}
+
+BYTE *dumpStack(StackFrame *stackFrame, BYTE *p, ULONG count)
+{
+
+   register int r;
+   ULONG *lp;
+
+   lp = (ULONG *) p;
+
+   DBGPrint("Stack = %04X:%08X\n", (unsigned)GetStackSegment(stackFrame),

+            (unsigned)p);
+
+   for (r=0; r < count; r++)
+   {
+      DBGPrint("%08X ", (unsigned) p);
+      DBGPrint("%08X ", (unsigned) mdb_getword((ULONG)lp, 4));
+      if (DisplayClosestSymbol(mdb_getword((ULONG)lp, 4)))
+         DBGPrint("\n");
+
+      p = (void *)((ULONG) p + (ULONG) 4);
+      lp = (ULONG *) p;
+   }
+
+   return p;
+
+}
+
+ULONG displayToggleHelp(BYTE *commandLine, DEBUGGER_PARSER *parser) +{
+    if (commandLine) {}
+    if (parser) {}
+
+    DBGPrint(".tc                      - toggles control registers (ON |
OFF)\n");
+    DBGPrint(".tn                      - toggles coprocessor registers
(ON | OFF)\n");
+    DBGPrint(".ts                      - toggles segment registers (ON |
OFF)\n");
+    DBGPrint(".tg                      - toggles general registers (ON |
OFF)\n");
+    DBGPrint(".tr                      - toggles display of break reason
(ON | OFF)\n");
+    DBGPrint(".td                      - toggles full dereference display
(ON | OFF)\n");
+    DBGPrint(".tl                      - toggles source line display (ON
| OFF)\n");
+    DBGPrint(".tu                      - toggles unasm debug display (ON
| OFF)\n");
+    DBGPrint(".t or .t <address>       - display task state segment
(tss)\n");
+    return TRUE;
+}
+
+// .TU
+
+ULONG ProcessTUToggle(BYTE *cmd,
+		   StackFrame *stackFrame, ULONG Exception,
+		   DEBUGGER_PARSER *parser)
+{
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     (debug_deref)
+     ? (debug_deref = 0)
+     : (debug_deref = 1);
+     DBGPrint("toggle unasm debug display (%s)\n",
+				  debug_deref ? "ON" : "OFF");
+     return TRUE;
+}
+
+// .TD
+
+ULONG ProcessTDToggle(BYTE *cmd,
+		   StackFrame *stackFrame, ULONG Exception,
+		   DEBUGGER_PARSER *parser)
+{
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     (full_deref_toggle)
+     ? (full_deref_toggle = 0)
+     : (full_deref_toggle = 1);
+     DBGPrint("toggle full dereferencing info (%s) \n",
+					    full_deref_toggle ? "ON" : "OFF");
+     return TRUE;
+}
+
+
+// .TL
+
+ULONG ProcessTLToggle(BYTE *cmd,
+		   StackFrame *stackFrame, ULONG Exception,
+		   DEBUGGER_PARSER *parser)
+{
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     (line_info_toggle)
+     ? (line_info_toggle = 0)
+     : (line_info_toggle = 1);
+     DBGPrint("toggle source line info (%s) \n",
+					    line_info_toggle ? "ON" : "OFF");
+     return TRUE;
+
+}
+
+// .TG
+
+ULONG ProcessTGToggle(BYTE *cmd,
+		   StackFrame *stackFrame, ULONG Exception,
+		   DEBUGGER_PARSER *parser)
+{
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     (general_toggle)
+     ? (general_toggle = 0)
+     : (general_toggle = 1);
+     DBGPrint("toggle general registers (%s) \n",
+					    general_toggle ? "ON" : "OFF");
+     return TRUE;
+
+}
+
+// .TC
+
+ULONG ProcessTCToggle(BYTE *cmd,
+		   StackFrame *stackFrame, ULONG Exception,
+		   DEBUGGER_PARSER *parser)
+{
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     (control_toggle)
+     ? (control_toggle = 0)
+     : (control_toggle = 1);
+     DBGPrint("toggle control registers (%s) \n",
+					    control_toggle ? "ON" : "OFF");
+     return TRUE;
+
+}
+
+// .TN
+
+ULONG ProcessTNToggle(BYTE *cmd,
+		   StackFrame *stackFrame, ULONG Exception,
+		   DEBUGGER_PARSER *parser)
+{
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     (numeric_toggle)
+     ? (numeric_toggle = 0)
+     : (numeric_toggle = 1);
+     DBGPrint("toggle coprocessor registers (%s) \n",
+					    numeric_toggle ? "ON" : "OFF");
+     return TRUE;
+
+}
+
+// .TR
+
+ULONG ProcessTRToggle(BYTE *cmd,
+		   StackFrame *stackFrame, ULONG Exception,
+		   DEBUGGER_PARSER *parser)
+{
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     (reason_toggle)
+     ? (reason_toggle = 0)
+     : (reason_toggle = 1);
+     DBGPrint("toggle display break reason (%s) \n",
+					    reason_toggle ? "ON" : "OFF");
+     return TRUE;
+
+}
+
+// .TS
+
+ULONG ProcessTSToggle(BYTE *cmd,
+		   StackFrame *stackFrame, ULONG Exception,
+		   DEBUGGER_PARSER *parser)
+{
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     (segment_toggle)
+     ? (segment_toggle = 0)
+     : (segment_toggle = 1);
+     DBGPrint("toggle segment registers (%s) \n",
+					    segment_toggle ? "ON" : "OFF");
+     return TRUE;
+
+}
+
+ULONG displayDebuggerVersionHelp(BYTE *commandLine, DEBUGGER_PARSER *parser)
+{
+    if (commandLine) {}
+    if (parser) {}
+
+    DBGPrint(".v                       - display version info\n"); +   
return TRUE;
+}
+
+// .V
+
+ULONG DisplayDebuggerVersion(BYTE *cmd,
+		   StackFrame *stackFrame, ULONG Exception,
+		   DEBUGGER_PARSER *parser)
+{
+     extern ULONG MajorVersion;
+     extern ULONG MinorVersion;
+     extern ULONG BuildVersion;
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     DBGPrint("Merkey's Kernel Debugger\n");
+     DBGPrint("v%02d.%02d.%02d\n",
+              (int)MajorVersion, (int)MinorVersion, (int)BuildVersion); +
    DBGPrint("Copyright (C) 2008 Jeffrey Vernon Merkey.  "
+              "All Rights Reserved.\n");
+
+     return TRUE;
+}
+
+// .Z
+
+ULONG displaySymbolsHelp(BYTE *commandLine, DEBUGGER_PARSER *parser) +{
+    if (commandLine) {}
+    if (parser) {}
+
+    DBGPrint(".z <name>                  - display symbol info\n"); +   
return TRUE;
+}
+
+ULONG displaySymbols(BYTE *cmd,
+		    StackFrame *stackFrame, ULONG Exception,
+		    DEBUGGER_PARSER *parser)
+{
+     extern void DumpOSSymbolTableMatch(BYTE *);
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     cmd = &cmd[parser->debugCommandNameLength];
+     while (*cmd && *cmd == ' ') cmd++;
+
+     if (*cmd)
+	DumpOSSymbolTableMatch(cmd);
+     else
+	DumpOSSymbolTableMatch(NULL);
+
+     return TRUE;
+}
+
+// LCPU
+
+ULONG listProcessors(BYTE *cmd,
+		    StackFrame *stackFrame, ULONG Exception,
+		    DEBUGGER_PARSER *parser)
+{
+     register int i;
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     cmd = &cmd[parser->debugCommandNameLength];
+     while (*cmd && *cmd == ' ') cmd++;
+
+     DBGPrint("Current Processor: %d\n", smp_processor_id());
+     DBGPrint("Active Processors: \n");
+     for (i=0; i < MAX_PROCESSORS; i++)
+     {
+        if (cpu_online(i))
+	   DBGPrint("   Processor %d\n", i);
+     }
+     return TRUE;
+
+}
+
+ULONG clearScreenHelp(BYTE *commandLine, DEBUGGER_PARSER *parser) +{
+    if (commandLine) {}
+    if (parser) {}
+
+    DBGPrint("cls                      - clear the screen\n");
+    return TRUE;
+}
+
+// CLS
+
+ULONG clearDebuggerScreen(BYTE *cmd,
+			 StackFrame *stackFrame, ULONG Exception,
+			 DEBUGGER_PARSER *parser)
+{
+     extern void ClearScreen(void);
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     ClearScreen();
+     return TRUE;
+
+}
+
+ULONG SearchMemoryHelp(BYTE *commandLine, DEBUGGER_PARSER *parser) +{
+    if (commandLine) {}
+    if (parser) {}
+
+    DBGPrint("sb                       - search for bytes at address\n");
+    DBGPrint("sw                       - search for words at address\n");
+    DBGPrint("sd                       - search for dwords at
address\n");
+    return TRUE;
+}
+
+// S
+
+// use local storage and reduce stack space use.  these functions are always
+// called single threaded from the console
+
+BYTE s_changeBuffer[16];
+BYTE b_searchBuffer[16];
+BYTE b_copyBuffer[16];
+WORD w_searchBuffer[16];
+WORD w_copyBuffer[16];
+ULONG d_searchBuffer[16];
+ULONG d_copyBuffer[16];
+
+ULONG SearchMemory(BYTE *cmd,
+	       StackFrame *stackFrame, ULONG Exception,
+	       DEBUGGER_PARSER *parser)
+{
+     BYTE *changeBuffer = s_changeBuffer;
+     BYTE *searchBuffer = b_searchBuffer;
+     BYTE *copyBuffer = b_copyBuffer;
+     ULONG maxlen = sizeof(searchBuffer);
+     register BYTE *changeB;
+     BYTE *pB;
+     register ULONG address, r, value, count, len, i;
+     ULONG valid, EndingAddress = (ULONG)high_memory;
+     register int key;
+     extern int mdb_getkey(void);
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     cmd = &cmd[parser->debugCommandNameLength];
+     while (*cmd && *cmd == ' ') cmd++;
+
+     memset((ULONG *)searchBuffer, 0, sizeof(searchBuffer));
+     count = 0;
+     changeB = (BYTE *) searchBuffer;
+     changeBuffer[0] = '\0';
+     DBGPrint("enter bytes to search for, '.' to end input\n");
+     while ((changeBuffer[0] != '.') && (count < maxlen))
+     {
+	for (r=0; r < 8; r++)
+	{
+	   DBGPrint("0x");
+
+	   ScreenInputFromKeyboard(&changeBuffer[0], 0, 4);
+
+	   if ((changeBuffer[0] == '.') || (changeBuffer[1] == '.'))
+	      break;
+
+	   pB = (BYTE *) &changeBuffer[0];
+	   len = strlen(pB);
+
+	   for (i=0; i < len; i++)
+	      DBGPrint("\b");
+
+	   value = EvaluateExpression(0, &pB, &valid);
+	   if (valid)
+	      *changeB = (BYTE) value;
+	   DBGPrint("%02X ", (BYTE) *changeB);
+
+	   changeB++;
+	   if (count++ > maxlen)
+	      break;
+	}
+	if (DBGPrint("\n")) return TRUE;
+     }
+
+     if (count)
+     {
+	DBGPrint("enter start address for search:  ");
+	ScreenInputFromKeyboard(&changeBuffer[0], 0, 16);
+	pB = (BYTE *) &changeBuffer[0];
+	address = EvaluateExpression(0, &pB, &valid);
+	if (valid)
+	{
+	   register ULONG temp;
+
+	   DBGPrint("start address = [%08X]\n", (unsigned)address);
+	   DBGPrint("enter ending address for search:  ");
+
+	   ScreenInputFromKeyboard(&changeBuffer[0], 0, 16);
+	   pB = (BYTE *) &changeBuffer[0];
+	   temp = EvaluateExpression(0, &pB, &valid);
+	   if (valid)
+	      EndingAddress = temp;
+
+	   DBGPrint("\nsearching memory from 0x%08X to 0x%08X\n",
+                    (unsigned)address, (unsigned)EndingAddress);
+	   while (address < EndingAddress)
+	   {
+              read_memory((void *)address, copyBuffer, count);
+	      if (!memcmp(searchBuffer, copyBuffer, count))
+	      {
+		 if (DBGPrint("match at address [%08X]\n",
+                     (unsigned)address)) return TRUE;
+		 if (dumpSearchResults((BYTE *)address, 4)) return TRUE;
+		 if (DBGPrint("searching\n")) return TRUE;
+	      }
+	      address++;
+	      if (!(address % 0x100000))
+	      {
+		  if (DBGPrint("searching memory at address 0x%08X ..."
+                        " Q or q to abort - any key to proceed\n", +     
                          (unsigned)address)) return TRUE;
+                  key = mdb_getkey();
+                  if (((char)key == 'Q') || ((char)key == 'q'))
+                     break;
+	      }
+	   }
+	   if (DBGPrint("search completed.\n")) return TRUE;
+	   return TRUE;
+	}
+	if (DBGPrint("invalid start address\n")) return TRUE;
+	return TRUE;
+     }
+     if (DBGPrint("no search pattern\n")) return TRUE;
+     return TRUE;
+
+}
+
+// SB
+
+ULONG SearchMemoryB(BYTE *cmd,
+	       StackFrame *stackFrame, ULONG Exception,
+	       DEBUGGER_PARSER *parser)
+{
+     BYTE *changeBuffer = s_changeBuffer;
+     BYTE *searchBuffer = b_searchBuffer;
+     BYTE *copyBuffer = b_copyBuffer;
+     ULONG maxlen = sizeof(searchBuffer);
+     register BYTE *changeB;
+     BYTE *pB;
+     register ULONG address, r, value, count, len, i;
+     ULONG valid, EndingAddress = (ULONG)high_memory;
+     register int key;
+     extern int mdb_getkey(void);
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     cmd = &cmd[parser->debugCommandNameLength];
+     while (*cmd && *cmd == ' ') cmd++;
+
+     memset((ULONG *)searchBuffer, 0, sizeof(searchBuffer));
+     count = 0;
+     changeB = (BYTE *) searchBuffer;
+     changeBuffer[0] = '\0';
+     DBGPrint("enter bytes to search for, '.' to end input\n");
+     while (changeBuffer[0] != '.' && count < maxlen)
+     {
+	for (r=0; r < 8; r++)
+	{
+	   DBGPrint("0x");
+
+	   ScreenInputFromKeyboard(&changeBuffer[0], 0, 4);
+
+	   if ((changeBuffer[0] == '.') || (changeBuffer[1] == '.'))
+	      break;
+
+	   pB = (BYTE *) &changeBuffer[0];
+	   len = strlen(pB);
+	   for (i=0; i < len; i++)
+	      DBGPrint("\b");
+
+	   value = EvaluateExpression(0, &pB, &valid);
+	   if (valid)
+	      *changeB = (BYTE) value;
+	   DBGPrint("%02X ", (BYTE) *changeB);
+
+	   changeB++;
+	   if (count++ > maxlen)
+	      break;
+	}
+	if (DBGPrint("\n")) return TRUE;
+     }
+
+     if (count)
+     {
+	DBGPrint("enter start address for search:  ");
+	ScreenInputFromKeyboard(&changeBuffer[0], 0, 16);
+	pB = (BYTE *) &changeBuffer[0];
+	address = EvaluateExpression(0, &pB, &valid);
+	if (valid)
+	{
+	   register ULONG temp;
+
+	   DBGPrint("start address = [%08X]\n", (unsigned)address);
+
+	   DBGPrint("enter ending address for search:  ");
+	   ScreenInputFromKeyboard(&changeBuffer[0], 0, 16);
+	   pB = (BYTE *) &changeBuffer[0];
+	   temp = EvaluateExpression(0, &pB, &valid);
+	   if (valid)
+	      EndingAddress = temp;
+
+	   DBGPrint("\nsearching memory from 0x%08X to 0x%08X\n",
+                    (unsigned)address, (unsigned)EndingAddress);
+	   while (address < EndingAddress)
+	   {
+              read_memory((void *)address, copyBuffer, count);
+	      if (!memcmp(searchBuffer, copyBuffer, count))
+	      {
+		 if (DBGPrint("match at address [%08X]\n",
+                     (unsigned)address)) return TRUE;
+		 if (dumpSearchResults((BYTE *)address, 4)) return TRUE;
+		 if (DBGPrint("searching\n")) return TRUE;
+	      }
+	      address++;
+	      if (!(address % 0x100000))
+	      {
+		 if (DBGPrint("searching memory at address 0x%08X ..."
+                        " Q or q to abort - any key to proceed\n", +     
                        (unsigned)address)) return TRUE;
+                 key = mdb_getkey();
+                 if (((char)key == 'Q') || ((char)key == 'q'))
+                    break;
+	      }
+	   }
+	   if (DBGPrint("search completed.\n")) return TRUE;
+	   return TRUE;
+	}
+	if (DBGPrint("invalid start address\n")) return TRUE;
+	return TRUE;
+     }
+     if (DBGPrint("no search pattern\n")) return TRUE;
+     return TRUE;
+}
+
+// SW
+
+ULONG SearchMemoryW(BYTE *cmd,
+	       StackFrame *stackFrame, ULONG Exception,
+	       DEBUGGER_PARSER *parser)
+{
+     BYTE *changeBuffer = s_changeBuffer;
+     WORD *searchBuffer = w_searchBuffer;
+     WORD *copyBuffer = w_copyBuffer;
+     ULONG maxlen = sizeof(searchBuffer) / sizeof(WORD);
+     register WORD *changeW;
+     BYTE *pB;
+     register ULONG address, r, value, count, len, i;
+     ULONG valid, EndingAddress = (ULONG)high_memory;
+     register int key;
+     extern int mdb_getkey(void);
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     cmd = &cmd[parser->debugCommandNameLength];
+     while (*cmd && *cmd == ' ') cmd++;
+
+     memset((ULONG *)searchBuffer, 0, sizeof(searchBuffer));
+     count = 0;
+     changeW = (WORD *) searchBuffer;
+     changeBuffer[0] = '\0';
+     DBGPrint("enter words to search for, '.' to end input\n");
+     while (changeBuffer[0] != '.' && count < maxlen)
+     {
+	for (r=0; r < 4; r++)
+	{
+	   DBGPrint("0x");
+
+	   ScreenInputFromKeyboard(&changeBuffer[0], 0, 6);
+
+	   if ((changeBuffer[0] == '.') || (changeBuffer[1] == '.') ||
+	       (changeBuffer[2] == '.') || (changeBuffer[3] == '.'))
+	      break;
+
+	   pB = (BYTE *) &changeBuffer[0];
+	   len = strlen(pB);
+	   for (i=0; i < len; i++)
+	      DBGPrint("\b");
+
+	   value = EvaluateExpression(0, &pB, &valid);
+	   if (valid)
+	      *changeW = value;
+	   DBGPrint("%04X ", *changeW);
+
+	   changeW++;
+	   if (count++ > maxlen)
+	      break;
+	}
+	if (DBGPrint("\n")) return TRUE;
+     }
+
+     if (count)
+     {
+	DBGPrint("enter start address for search:  ");
+	ScreenInputFromKeyboard(&changeBuffer[0], 0, 16);
+	pB = (BYTE *) &changeBuffer[0];
+	address = EvaluateExpression(0, &pB, &valid);
+	if (valid)
+	{
+	   register ULONG temp;
+
+	   DBGPrint("start address = [%08X]\n", (unsigned)address);
+
+	   DBGPrint("enter ending address for search:  ");
+	   ScreenInputFromKeyboard(&changeBuffer[0], 0, 16);
+	   pB = (BYTE *) &changeBuffer[0];
+	   temp = EvaluateExpression(0, &pB, &valid);
+	   if (valid)
+	      EndingAddress = temp;
+
+	   DBGPrint("searching memory from 0x%08X to 0x%08X\n",
+                    (unsigned)address, (unsigned)EndingAddress);
+	   while (address < EndingAddress)
+	   {
+              read_memory((void *)address, copyBuffer, count *
sizeof(WORD));
+	      if (!memcmp(searchBuffer, copyBuffer, count * sizeof(WORD))) +	   
  {
+		 if (DBGPrint("match at address [%08X]\n",
+                     (unsigned)address)) return TRUE;
+		 if (dumpWordSearchResults((BYTE *)address, 4))
+                     return TRUE;
+		 if (DBGPrint("searching\n")) return TRUE;;
+	      }
+	      address++;
+	      if (!(address % 0x100000))
+	      {
+		 if (DBGPrint("searching memory at address 0x%08X ..."
+                        " Q or q to abort - any key to proceed\n", +     
                        (unsigned)address)) return TRUE;
+                  key = mdb_getkey();
+                  if (((char)key == 'Q') || ((char)key == 'q'))
+                     break;
+	      }
+	   }
+	   if (DBGPrint("search completed.\n")) return TRUE;
+	   return TRUE;
+	}
+	if (DBGPrint("invalid start address\n")) return TRUE;
+	return TRUE;
+     }
+     if (DBGPrint("no search pattern\n")) return TRUE;
+     return TRUE;
+}
+
+// SD
+
+ULONG SearchMemoryD(BYTE *cmd,
+	       StackFrame *stackFrame, ULONG Exception,
+	       DEBUGGER_PARSER *parser)
+{
+     register BYTE *changeBuffer = s_changeBuffer;
+     register ULONG *searchBuffer = d_searchBuffer;
+     register ULONG *copyBuffer = d_copyBuffer;
+     register ULONG maxlen = sizeof(searchBuffer) / sizeof(ULONG); +    
register ULONG *changeD;
+     BYTE *pB;
+     register ULONG address, r, value, count, len, i;
+     ULONG valid, EndingAddress = (ULONG)high_memory;
+     register int key;
+     extern int mdb_getkey(void);
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     cmd = &cmd[parser->debugCommandNameLength];
+     while (*cmd && *cmd == ' ') cmd++;
+
+     memset((ULONG *)searchBuffer, 0, sizeof(searchBuffer));
+     count = 0;
+     changeD = (ULONG *) searchBuffer;
+     changeBuffer[0] = '\0';
+     DBGPrint("enter dwords to search for, '.' to end input\n");
+     while (changeBuffer[0] != '.' && count < maxlen)
+     {
+	for (r=0; r < 2; r++)
+	{
+	   DBGPrint("0x");
+
+	   ScreenInputFromKeyboard(&changeBuffer[0], 0, 8);
+
+	   if ((changeBuffer[0] == '.') || (changeBuffer[1] == '.') ||
+	       (changeBuffer[2] == '.') || (changeBuffer[3] == '.') ||
+	       (changeBuffer[4] == '.') || (changeBuffer[5] == '.') ||
+	       (changeBuffer[6] == '.') || (changeBuffer[7] == '.'))
+	      break;
+
+	   pB = (BYTE *) &changeBuffer[0];
+	   len = strlen(pB);
+	   for (i=0; i < len; i++)
+	      DBGPrint("\b");
+
+	   value = EvaluateExpression(0, &pB, &valid);
+	   if (valid)
+	      *changeD = value;
+	   DBGPrint("%08X ", (unsigned)*changeD);
+
+	   changeD++;
+	   if (count++ > maxlen)
+	      break;
+	}
+	if (DBGPrint("\n")) return TRUE;
+     }
+
+     if (count)
+     {
+	DBGPrint("enter start address for search:  ");
+	ScreenInputFromKeyboard(&changeBuffer[0], 0, 16);
+	pB = (BYTE *) &changeBuffer[0];
+	address = EvaluateExpression(0, &pB, &valid);
+	if (valid)
+	{
+	   register ULONG temp;
+
+	   DBGPrint("start address = [%08X]\n", (unsigned)address);
+
+	   DBGPrint("enter ending address for search:  ");
+	   ScreenInputFromKeyboard(&changeBuffer[0], 0, 16);
+	   pB = (BYTE *) &changeBuffer[0];
+	   temp = EvaluateExpression(0, &pB, &valid);
+	   if (valid)
+	      EndingAddress = temp;
+
+	   DBGPrint("searching memory from 0x%08X to 0x%08X\n",
+                    (unsigned)address, (unsigned)EndingAddress);
+	   while (address < EndingAddress)
+	   {
+              read_memory((void *)address, copyBuffer, count *
sizeof(ULONG));
+	      if (!memcmp(searchBuffer, copyBuffer, count * sizeof(ULONG))) +	  
   {
+		 if (DBGPrint("match at address [%08X]\n",
+                     (unsigned)address)) return TRUE;
+		 if (dumpDoubleSearchResults((BYTE *)address, 4))
+                     return TRUE;
+		 if (DBGPrint("searching\n")) return TRUE;
+	      }
+	      address++;
+	      if (!(address % 0x100000))
+	      {
+		 if (DBGPrint("searching memory at address 0x%08X ..."
+                        " Q or q to abort - any key to proceed\n", +     
                        (unsigned)address)) return TRUE;
+                  key = mdb_getkey();
+                  if (((char)key == 'Q') || ((char)key == 'q'))
+                     break;
+	      }
+	   }
+	   if (DBGPrint("search completed.\n")) return TRUE;
+	   return TRUE;
+	}
+	if (DBGPrint("invalid start address\n")) return TRUE;
+	return TRUE;
+     }
+     if (DBGPrint("no search pattern\n")) return TRUE;
+     return TRUE;
+}
+
+
+ULONG changeMemoryHelp(BYTE *commandLine, DEBUGGER_PARSER *parser) +{
+    if (commandLine) {}
+    if (parser) {}
+
+    DBGPrint("c   <address>            - change bytes at address\n"); +  
 DBGPrint("cb  <address>            - change bytes at address\n"); +   
DBGPrint("cw  <address>            - change words at address\n"); +   
DBGPrint("cd  <address>            - change dwords at address\n"); +   
return TRUE;
+}
+
+// CW
+
+ULONG changeWordValue(BYTE *cmd,
+	       StackFrame *stackFrame, ULONG Exception,
+	       DEBUGGER_PARSER *parser)
+{
+     register BYTE *changeBuffer = &workbuf[0][0];
+     register WORD *changeW, oldW;
+     BYTE *pB;
+     register ULONG address, r, value, len, i;
+     ULONG valid;
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     cmd = &cmd[parser->debugCommandNameLength];
+     while (*cmd && *cmd == ' ') cmd++;
+
+     address = EvaluateExpression(stackFrame, &cmd, &valid);
+     if (valid)
+     {
+	changeW = (WORD *) address;
+	changeBuffer[0] = '\0';
+	DBGPrint("enter new value, <enter> to skip, or '.' to exit\n");
+	while (changeBuffer[0] != '.')
+	{
+	   DBGPrint("[%08X] ", (unsigned)changeW);
+	   for (r=0; r < 4; r++)
+	   {
+	      oldW = (WORD) mdb_getword((ULONG)changeW, 2);
+	      DBGPrint("(%04X)=", (unsigned) oldW);
+
+              ScreenInputFromKeyboard(&changeBuffer[0], 0, 6);
+
+	      if ((changeBuffer[0] == '.') || (changeBuffer[1] == '.') || +		 
(changeBuffer[2] == '.') || (changeBuffer[3] == '.'))
+		 break;
+	      pB = (BYTE *) &changeBuffer[0];
+	      len = strlen(pB);
+
+	      for (i=0; i < len; i++)
+		 DBGPrint("\b");
+
+	      value = EvaluateExpression(0, &pB, &valid);
+	      if (valid)
+		 mdb_putword((ULONG)changeW, value, 2);
+	      DBGPrint("%04X ", (unsigned) mdb_getword((ULONG)changeW, 2)); +	  
   changeW++;
+	   }
+	   if (DBGPrint("\n")) return TRUE;
+	}
+	return TRUE;
+     }
+     DBGPrint("invalid change (word) address\n");
+     return TRUE;
+}
+
+// CD
+
+ULONG changeDoubleValue(BYTE *cmd,
+	       StackFrame *stackFrame, ULONG Exception,
+	       DEBUGGER_PARSER *parser)
+{
+     register BYTE *changeBuffer = &workbuf[0][0];
+     register ULONG *changeD, oldD;
+     register ULONG address, r, value, len, i;
+     BYTE *pB;
+     ULONG valid;
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     cmd = &cmd[parser->debugCommandNameLength];
+     while (*cmd && *cmd == ' ') cmd++;
+
+     address = EvaluateExpression(stackFrame, &cmd, &valid);
+     if (valid)
+     {
+	changeD = (ULONG *) address;
+	changeBuffer[0] = '\0';
+	DBGPrint("enter new value, <enter> to skip, or '.' to exit\n");
+	while (changeBuffer[0] != '.')
+	{
+	   DBGPrint("[%08X] ", (unsigned)changeD);
+	   for (r=0; r < 2; r++)
+	   {
+	      oldD = (ULONG) mdb_getword((ULONG)changeD, 4);
+	      DBGPrint("(%08X)=", (unsigned) oldD);
+
+	      ScreenInputFromKeyboard(&changeBuffer[0], 0, 8);
+
+	      if ((changeBuffer[0] == '.') || (changeBuffer[1] == '.') || +		 
(changeBuffer[2] == '.') || (changeBuffer[3] == '.') ||
+		  (changeBuffer[4] == '.') || (changeBuffer[5] == '.') ||
+		  (changeBuffer[6] == '.') || (changeBuffer[7] == '.'))
+		 break;
+
+	      pB = (BYTE *) &changeBuffer[0];
+	      len = strlen(pB);
+
+	      for (i=0; i < len; i++)
+		 DBGPrint("\b");
+
+	      value = EvaluateExpression(0, &pB, &valid);
+	      if (valid)
+		 mdb_putword((ULONG)changeD, value, 4);
+	      DBGPrint("%08X ", (unsigned)mdb_getword((ULONG)changeD, 4)); +	   
  changeD++;
+	   }
+	   if (DBGPrint("\n")) return TRUE;
+	}
+	return TRUE;
+     }
+     DBGPrint("invalid change (dword) address\n");
+     return TRUE;
+}
+
+// CB
+
+ULONG changeByteValue(BYTE *cmd,
+	       StackFrame *stackFrame, ULONG Exception,
+	       DEBUGGER_PARSER *parser)
+{
+     BYTE *changeBuffer = &workbuf[0][0];
+     register BYTE *changeB, oldB;
+     BYTE *pB;
+     register ULONG address, r, value, len, i;
+     ULONG valid;
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     cmd = &cmd[parser->debugCommandNameLength];
+     while (*cmd && *cmd == ' ') cmd++;
+
+     address = EvaluateExpression(stackFrame, &cmd, &valid);
+     if (valid)
+     {
+	changeB = (BYTE *) address;
+	changeBuffer[0] = '\0';
+	DBGPrint("enter new value, <enter> to skip, or '.' to exit\n");
+	while (changeBuffer[0] != '.')
+	{
+	   DBGPrint("[%08X] ", (unsigned)changeB);
+	   for (r=0; r < 8; r++)
+	   {
+	      oldB = (BYTE) mdb_getword((ULONG)changeB, 1);
+	      DBGPrint("(%02X)=", (unsigned) oldB);
+
+	      ScreenInputFromKeyboard(&changeBuffer[0], 0, 4);
+
+	      if ((changeBuffer[0] == '.') || (changeBuffer[1] == '.'))
+		 break;
+
+	      pB = (BYTE *) &changeBuffer[0];
+	      len = strlen(pB);
+	      for (i=0; i < len; i++)
+		 DBGPrint("\b");
+
+	      value = EvaluateExpression(0, &pB, &valid);
+	      if (valid)
+		 mdb_putword((ULONG)changeB, value, 1);
+	      DBGPrint("%02X ", (BYTE) mdb_getword((ULONG)changeB, 1));
+	      changeB++;
+	   }
+	   if (DBGPrint("\n")) return TRUE;
+	}
+	return TRUE;
+     }
+     DBGPrint("invalid change (byte) address\n");
+     return TRUE;
+}
+
+// C
+
+ULONG changeDefaultValue(BYTE *cmd,
+			StackFrame *stackFrame, ULONG Exception,
+			DEBUGGER_PARSER *parser)
+{
+     BYTE *changeBuffer = &workbuf[0][0];
+     register BYTE *changeB, oldB;
+     BYTE *pB;
+     register ULONG address, r, value, len, i;
+     ULONG valid;
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     cmd = &cmd[parser->debugCommandNameLength];
+     while (*cmd && *cmd == ' ') cmd++;
+
+     address = EvaluateExpression(stackFrame, &cmd, &valid);
+     if (valid)
+     {
+	changeB = (BYTE *) address;
+	changeBuffer[0] = '\0';
+	DBGPrint("enter new value, <enter> to skip, or '.' to exit\n");
+	while (changeBuffer[0] != '.')
+	{
+	   DBGPrint("[%08X] ", (unsigned)changeB);
+	   for (r=0; r < 8; r++)
+	   {
+	      oldB = (BYTE) mdb_getword((ULONG)changeB, 1);
+	      DBGPrint("(%02X)=", (BYTE) oldB);
+
+	      ScreenInputFromKeyboard(&changeBuffer[0], 0, 4);
+
+	      if ((changeBuffer[0] == '.') || (changeBuffer[1] == '.'))
+		 break;
+
+	      pB = (BYTE *) &changeBuffer[0];
+	      len = strlen(pB);
+
+	      for (i=0; i < len; i++)
+		 DBGPrint("\b");
+
+	      value = EvaluateExpression(0, &pB, &valid);
+	      if (valid)
+		 mdb_putword((ULONG)changeB, value, 1);
+	      DBGPrint("%02X ", (BYTE) mdb_getword((ULONG)changeB, 1));
+	      changeB++;
+	   }
+	   if (DBGPrint("\n")) return TRUE;
+	}
+	return TRUE;
+     }
+     DBGPrint("invalid change (byte) address\n");
+     return TRUE;
+
+}
+
+ULONG displayCloseHelp(BYTE *commandLine, DEBUGGER_PARSER *parser) +{
+    if (commandLine) {}
+    if (parser) {}
+
+    DBGPrint("?   <address>            - display closest symbols to
<address>\n");
+    return TRUE;
+
+}
+
+// ?
+
+ULONG displayCloseSymbols(BYTE *cmd,
+			 StackFrame *stackFrame, ULONG Exception,
+			 DEBUGGER_PARSER *parser)
+{
+     register ULONG oldD;
+     ULONG valid;
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     cmd = &cmd[parser->debugCommandNameLength];
+     while (*cmd && *cmd == ' ') cmd++;
+
+     oldD = EvaluateExpression(stackFrame, &cmd, &valid);
+     if (!valid)
+	oldD = GetIP(stackFrame);
+     DisplayClosestSymbol(oldD);
+     return TRUE;
+
+}
+
+ULONG debuggerWalkStack(BYTE *cmd,
+		       StackFrame *stackFrame, ULONG Exception,
+		       DEBUGGER_PARSER *parser)
+{
+     ULONG valid;
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     cmd = &cmd[parser->debugCommandNameLength];
+     while (*cmd && *cmd == ' ') cmd++;
+
+     if (repeatCommand)
+     {
+	lastDumpAddress = dumpStack(stackFrame,
+                          (BYTE *)lastDumpAddress, lastDisplayLength);
+	return TRUE;
+     }
+     lastDumpAddress = (BYTE *) EvaluateExpression(stackFrame, &cmd,
&valid);
+     if (!valid)
+	lastDumpAddress = (BYTE *) GetStackAddress(stackFrame);
+     displayLength = EvaluateExpression(stackFrame, &cmd, &valid); +    
if (!displayLength || displayLength > 20)
+	displayLength = 20;
+     lastDumpAddress = dumpStack(stackFrame, (BYTE *)lastDumpAddress,
displayLength);
+     return TRUE;
+
+}
+
+ULONG displayDumpHelp(BYTE *commandLine, DEBUGGER_PARSER *parser) +{
+    if (commandLine) {}
+    if (parser) {}
+
+    DBGPrint("d   <address> <#lines>   - dump memory as bytes\n"); +   
DBGPrint("dw  <address> <#lines>   - dump memory as words\n"); +   
DBGPrint("dd  <address> <#lines>   - dump memory as double words\n"); +   
DBGPrint("dl  <address> <#lines>   - dump linked list\n");
+    DBGPrint("ds  <address> <#lines>   - dump stack\n");
+    DBGPrint("dds <address> <#lines>   - dump stack double word\n"); +   
DBGPrint("w   <address>            - display symbols on the
stack\n");
+
+    return TRUE;
+}
+
+// DL
+
+ULONG debuggerDumpLinkedList(BYTE *cmd,
+			    StackFrame *stackFrame, ULONG Exception,
+			    DEBUGGER_PARSER *parser)
+{
+     ULONG valid;
+     extern volatile BYTE *lastLinkAddress;
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     cmd = &cmd[parser->debugCommandNameLength];
+     while (*cmd && *cmd == ' ') cmd++;
+
+     if (repeatCommand)
+     {
+	lastLinkAddress = dumpLinkedList((BYTE *)lastLinkAddress,
lastDisplayLength, 0);
+	return TRUE;
+     }
+
+     lastLinkAddress = (BYTE *) EvaluateNumericExpression(stackFrame, &cmd,
+                                                          &valid); +    
if (!valid)
+	lastLinkAddress = (BYTE *) GetStackAddress(stackFrame);
+
+     displayLength = EvaluateNumericExpression(stackFrame, &cmd, &valid);
+     if (!displayLength || displayLength > 20)
+	displayLength = 20;
+
+     lastLinkAddress = dumpLinkedList((BYTE *)lastLinkAddress,
displayLength, 0);
+
+     return TRUE;
+
+}
+
+// DW
+
+ULONG debuggerDumpWord(BYTE *cmd,
+		      StackFrame *stackFrame, ULONG Exception,
+		      DEBUGGER_PARSER *parser)
+{
+     ULONG valid;
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     cmd = &cmd[parser->debugCommandNameLength];
+     while (*cmd && *cmd == ' ') cmd++;
+
+     if (repeatCommand)
+     {
+	lastDumpAddress = dumpWord((BYTE *)lastDumpAddress, lastDisplayLength);
+	return TRUE;
+     }
+     lastDumpAddress = (BYTE *) EvaluateExpression(stackFrame, &cmd,
&valid);
+     if (!valid)
+	lastDumpAddress = (BYTE *) GetStackAddress(stackFrame);
+     displayLength = EvaluateExpression(stackFrame, &cmd, &valid); +    
if (!displayLength || displayLength > 20)
+	displayLength = 20;
+     lastDumpAddress = dumpWord((BYTE *)lastDumpAddress, displayLength);
+     return TRUE;
+}
+
+// DS
+
+ULONG debuggerDumpStack(BYTE *cmd,
+		       StackFrame *stackFrame, ULONG Exception,
+		       DEBUGGER_PARSER *parser)
+{
+     ULONG valid;
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     cmd = &cmd[parser->debugCommandNameLength];
+     while (*cmd && *cmd == ' ') cmd++;
+
+     if (repeatCommand)
+     {
+	lastDumpAddress = dumpStack(stackFrame, (BYTE *)lastDumpAddress,
lastDisplayLength);
+	return TRUE;
+     }
+     lastDumpAddress = (BYTE *) EvaluateExpression(stackFrame, &cmd,
&valid);
+     if (!valid)
+	lastDumpAddress = (BYTE *) GetStackAddress(stackFrame);
+     displayLength = EvaluateExpression(stackFrame, &cmd, &valid); +    
if (!displayLength || displayLength > 20)
+	displayLength = 20;
+     lastDumpAddress = dumpStack(stackFrame, (BYTE *)lastDumpAddress,
displayLength);
+     return TRUE;
+
+}
+
+// DDS
+
+ULONG debuggerDumpDoubleStack(BYTE *cmd,
+			     StackFrame *stackFrame, ULONG Exception,
+			     DEBUGGER_PARSER *parser)
+{
+     ULONG valid;
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     cmd = &cmd[parser->debugCommandNameLength];
+     while (*cmd && *cmd == ' ') cmd++;
+
+     if (repeatCommand)
+     {
+	lastDumpAddress = dumpDoubleStack(stackFrame, (BYTE *)lastDumpAddress,
+						    lastDisplayLength);
+	return TRUE;
+     }
+     lastDumpAddress = (BYTE *) EvaluateExpression(stackFrame, &cmd,
&valid);
+     if (!valid)
+	lastDumpAddress = (BYTE *) GetStackAddress(stackFrame);
+     displayLength = EvaluateExpression(stackFrame, &cmd, &valid); +    
if (!displayLength || displayLength > 20)
+	displayLength = 20;
+     lastDumpAddress = dumpDoubleStack(stackFrame, (BYTE
*)lastDumpAddress,
+						    displayLength);
+     return TRUE;
+
+}
+
+// DD
+
+ULONG debuggerDumpDouble(BYTE *cmd,
+			StackFrame *stackFrame, ULONG Exception,
+			DEBUGGER_PARSER *parser)
+{
+     ULONG valid;
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     cmd = &cmd[parser->debugCommandNameLength];
+     while (*cmd && *cmd == ' ') cmd++;
+
+     if (repeatCommand)
+     {
+	lastDumpAddress = dumpDouble((BYTE *)lastDumpAddress,
lastDisplayLength);
+	return TRUE;
+     }
+     lastDumpAddress = (BYTE *) EvaluateExpression(stackFrame, &cmd,
&valid);
+     if (!valid)
+	lastDumpAddress = (BYTE *) GetStackAddress(stackFrame);
+     displayLength = EvaluateExpression(stackFrame, &cmd, &valid); +    
if (!displayLength || displayLength > 20)
+	displayLength = 20;
+     lastDumpAddress = dumpDouble((BYTE *)lastDumpAddress,
displayLength);
+     return TRUE;
+
+}
+
+// D
+
+ULONG debuggerDumpByte(BYTE *cmd,
+		      StackFrame *stackFrame, ULONG Exception,
+		      DEBUGGER_PARSER *parser)
+{
+     ULONG valid;
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     cmd = &cmd[parser->debugCommandNameLength];
+     while (*cmd && *cmd == ' ') cmd++;
+
+     if (repeatCommand)
+     {
+	lastDumpAddress = dump((BYTE *)lastDumpAddress, lastDisplayLength);
+	return TRUE;
+     }
+     lastDumpAddress = (BYTE *) EvaluateExpression(stackFrame, &cmd,
&valid);
+     if (!valid)
+	lastDumpAddress = (BYTE *) GetStackAddress(stackFrame);
+     displayLength = EvaluateExpression(stackFrame, &cmd, &valid); +    
if (!displayLength || displayLength > 20)
+	displayLength = 20;
+     lastDumpAddress = dump((BYTE *)lastDumpAddress, displayLength); +   
 return TRUE;
+
+}
+
+ULONG displayDisassembleHelp(BYTE *commandLine, DEBUGGER_PARSER *parser) +{
+    if (commandLine) {}
+    if (parser) {}
+
+    DBGPrint("id  <address> <#lines>   - unassemble code (32-bit)\n"); + 
  DBGPrint("u   <address> <#lines>   - unassemble code (32-bit)\n"); +   
DBGPrint("uu  <address> <#lines>   - unassemble code (16-bit)\n"); +   
return TRUE;
+}
+
+// UU
+
+ULONG processDisassemble16(BYTE *cmd,
+			  StackFrame *stackFrame, ULONG Exception,
+			  DEBUGGER_PARSER *parser)
+{
+     ULONG valid;
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     cmd = &cmd[parser->debugCommandNameLength];
+     while (*cmd && *cmd == ' ') cmd++;
+
+     if (repeatCommand)
+     {
+	lastUnasmAddress = disassemble(stackFrame, (ULONG)lastUnasmAddress,
+						    lastDisplayLength, 0);
+	return TRUE;
+     }
+     lastUnasmAddress = EvaluateExpression(stackFrame, &cmd, &valid); +  
  if (!valid)
+     {
+        if (!*cmd)
+	   lastUnasmAddress = GetIP(stackFrame);
+        else
+        {
+           DBGPrint("invalid address for unassemble\n");
+           return TRUE;
+        }
+     }
+     displayLength = EvaluateExpression(stackFrame, &cmd, &valid); +    
if (!displayLength || displayLength > 20)
+		     displayLength = 20;
+     lastUnasmAddress = disassemble(stackFrame, (ULONG)lastUnasmAddress,
+						 displayLength, 0);
+     return TRUE;
+}
+
+// U
+
+ULONG processDisassemble32(BYTE *cmd,
+			  StackFrame *stackFrame, ULONG Exception,
+			  DEBUGGER_PARSER *parser)
+{
+     ULONG valid;
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     cmd = &cmd[parser->debugCommandNameLength];
+     while (*cmd && *cmd == ' ') cmd++;
+
+     if (repeatCommand)
+     {
+	lastUnasmAddress = disassemble(stackFrame, (ULONG)lastUnasmAddress,
+				       lastDisplayLength, 1);
+	return TRUE;
+     }
+     lastUnasmAddress = EvaluateExpression(stackFrame, &cmd, &valid); +  
  if (!valid)
+     {
+        if (!*cmd)
+	   lastUnasmAddress = GetIP(stackFrame);
+        else
+        {
+           DBGPrint("invalid address for unassemble\n");
+           return TRUE;
+        }
+     }
+     displayLength = EvaluateExpression(stackFrame, &cmd, &valid); +    
if (!displayLength || displayLength > 20)
+	displayLength = 20;
+     lastUnasmAddress = disassemble(stackFrame, (ULONG)lastUnasmAddress,
+						 displayLength, 1);
+     return TRUE;
+
+}
+
+#endif

By making a contribution to this project, I certify that the contribution
was created in whole or in part by me and I have the right to submit it
under the open source license indicated in the file

Jeffrey Vernon Merkey




