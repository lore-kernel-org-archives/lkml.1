Return-Path: <linux-kernel-owner+w=401wt.eu-S1761467AbYHDGxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761467AbYHDGxU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 02:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759741AbYHDGxB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 02:53:01 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:48663 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759357AbYHDGwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 02:52:54 -0400
Message-ID: <37451.166.70.238.45.1217831548.squirrel@webmail.wolfmountaingroup.com>
Date: Mon, 4 Aug 2008 00:32:28 -0600 (MDT)
Subject: [PATCH 2.6.27-rc1 8/25] mdb:  Merkey's Kernel Debugger 2.6.27-rc1
From: jmerkey@wolfmountaingroup.com
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Netware style debugger for Linux written by Jeffrey Vernon Merkey

--- a/debug/mdb-ia32.c	1969-12-31 17:00:00.000000000 -0700
+++ b/debug/mdb-ia32.c	2008-08-03 16:15:00.000000000 -0600
@@ -0,0 +1,6011 @@
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
+*   FILE     :  MDB-IA32.C
+*   DESCRIP  :  Merkey's NetWare Debugger
+*   DATE     :  April 8, 2008
+*
+***************************************************************************/
+
+#include "mdb.h"
+
+#ifdef CONFIG_MDB
+
+ULONG MajorVersion = 8;
+ULONG MinorVersion = 8;
+ULONG BuildVersion = 8;
+
+extern ULONG needs_proceed;
+extern ULONG general_toggle;
+extern ULONG line_info_toggle;
+extern ULONG control_toggle;
+extern ULONG segment_toggle;
+extern ULONG numeric_toggle;
+extern ULONG reason_toggle;
+
+BYTE *IA32Flags[]=
+{
+   "CF", 0, "PF", 0, "AF",    0, "ZF", "SF", "TF", "IF", "DF", "OF",
+   0,    0, "NT", 0, "RF", "VM", "AC", "VIF","VIP","ID",    0,    0,
+   0,
+};
+
+BYTE *BreakDescription[]=
+{
+   "EXECUTE",  "WRITE",  "IOPORT",  "READ/WRITE",
+};
+
+BYTE *BreakLengthDescription[]={
+   ": 1 BYTE",  ": 2 BYTE",  ": ??????",  ": 4 BYTE",
+};
+
+BYTE *ExceptionDescription[]={
+   "Divide By Zero",                 //  0
+   "Debugger Exception (INT1)",      //  1
+   "Non-Maskable Interrupt",         //  2
+   "Debugger Breakpoint (INT3)",     //  3
+   "Overflow Exception",             //  4
+   "Bounds Check",                   //  5
+   "Invalid Opcode",                 //  6
+   "No Coprocessor",                 //  7
+   "Double Fault",                   //  8
+   "Cops Error",                     //  9
+   "Invalid Task State Segment",     //  10
+   "Segment Not Present",            //  11
+   "Stack Exception",                //  12
+   "General Protection",             //  13
+   "Page Fault",                     //  14
+   "InvalidInterrupt",               //  15
+   "Coprocessor Error",              //  16
+   "AlignmentCheck",                 //  17
+   "Machine Check",                  //  18
+   "Enter Debugger Request",         //  19
+   "Unvectored Exception",           //  20
+   "Directed NMI Breakpoint",        //  21
+   "Panic"                           //  22
+};
+ULONG exceptions = (sizeof(ExceptionDescription) / sizeof(BYTE *));
+
+BYTE char32spc[] = { "xxxúxxxúxxxúxxxùxxxúxxxúxxxúxxx " };
+BYTE flset[] = { "VMRF  NT    OFDNIETFMIZR  AC  PE  CY" };
+BYTE floff[] = { "              UPID  PLNZ      PO  NC" };
+BYTE fluse[] = { 1,1,0,1,0,0,1,1,1,1,1,1,0,1,0,1,0,1 };
+NUMERIC_FRAME npx[MAX_PROCESSORS];
+
+ULONG MTRR_BASE_REGS[] = {
+  MTRR_PHYS_BASE_0, MTRR_PHYS_BASE_1, MTRR_PHYS_BASE_2, MTRR_PHYS_BASE_3,
+  MTRR_PHYS_BASE_4, MTRR_PHYS_BASE_5, MTRR_PHYS_BASE_6, MTRR_PHYS_BASE_7
+};
+
+ULONG MTRR_MASK_VALUES[] = {
+  MTRR_PHYS_MASK_0, MTRR_PHYS_MASK_1, MTRR_PHYS_MASK_2, MTRR_PHYS_MASK_3,
+  MTRR_PHYS_MASK_4, MTRR_PHYS_MASK_5, MTRR_PHYS_MASK_6, MTRR_PHYS_MASK_7
+};
+
+
+
+StackFrame ReferenceFrame[MAX_PROCESSORS];
+
+typedef struct _RLOCK
+{
+#if defined(CONFIG_SMP)
+    spinlock_t lock;
+#endif
+    long flags;
+    int processor;
+    int count;
+} rlock_t;
+
+#define PROCESSOR_INACTIVE    0
+#define PROCESSOR_ACTIVE      1
+#define PROCESSOR_SUSPEND     2
+#define PROCESSOR_RESUME      3
+#define PROCESSOR_DEBUG       4
+#define PROCESSOR_SHUTDOWN    5
+#define PROCESSOR_IPI         6
+#define PROCESSOR_SWITCH      7
+#define PROCESSOR_HOLD        8
+
+#define PIC1_DEBUG_MASK    0xFC
+#define PIC2_DEBUG_MASK    0xFF
+
+#define  MAX_PICS             3
+#define  PIC_0             0x20
+#define  PIC_1             0xA0
+#define  PIC_2             0x30
+#define  MASK_0            0x21
+#define  MASK_1            0xA1
+#define  MASK_2            0x31
+
+BYTE irq_control[MAX_PICS] = { PIC_0, PIC_1, PIC_2 };
+BYTE irq_mask[MAX_PICS] = { MASK_0, MASK_1, MASK_2 };
+BYTE mask_value[MAX_PICS] = { 0xF8, 0xFF, 0xFF };
+
+#if defined(CONFIG_SMP)
+volatile rlock_t debug_mutex = { SPIN_LOCK_UNLOCKED, 0, -1, 0 };
+#else
+volatile rlock_t debug_mutex = { 0, -1, 0 };
+#endif
+
+volatile ULONG debuggerActive = 0;
+volatile ULONG ProcessorHold[MAX_PROCESSORS];
+volatile ULONG ProcessorState[MAX_PROCESSORS];
+volatile ULONG ProcessorMode[MAX_PROCESSORS];
+
+BYTE *procState[]={
+   "PROCESSOR_INACTIVE", "PROCESSOR_ACTIVE  ", "PROCESSOR_SUSPEND ",
+   "PROCESSOR_RESUME  ", "PROCESSOR_DEBUG   ", "PROCESSOR_SHUTDOWN",
+   "PROCESSOR_IPI     ", "PROCESSOR_SWITCH  ", "PROCESSOR_HOLD    ",
+   "?                 ", "?                 ", "?                 ",
+   "?                 ", "?                 ", "?                 ",
+   "?                 "
+};
+
+// debugger commands
+
+DEBUGGER_PARSER backTraceAllPidPE = {
+0, 0, backTraceAllPID, backTraceHelp, 0, "BTA", 0, 0,
+"display stack backtrace for all processes" , 0 };
+
+DEBUGGER_PARSER backTracePidPE = {
+0, 0, backTracePID, backTraceHelp, 0, "BTP", 0, 0,
+"display stack backtrace by pid" , 0 };
+
+DEBUGGER_PARSER backTraceStackPE = {
+0, 0, backTraceStack, backTraceHelp, 0, "BT", 0, 0,
+"display stack backtrace by address" , 0 };
+
+DEBUGGER_PARSER uFramePE = {
+0, 0, dump_uf, 0, 0, "UF", 0, 0,
+"display task eframe contents" , 0 };
+
+DEBUGGER_PARSER eFramePE = {
+0, 0, dump_ef, 0, 0, "EF", 0, 0,
+"display eframe contents" , 0 };
+
+DEBUGGER_PARSER cpuFramePE = {
+0, 0, listProcessorFrame, processorCommandHelp, 0, "LR", 0, 0,
+"display cpu registers" , 0 };
+
+DEBUGGER_PARSER ProcessorPE = {
+0, 0, displayProcessorStatus, displayProcessorStatusHelp, 0,
"PROCESSORS", 0, 0,
+"display processor status" , 0 };
+
+DEBUGGER_PARSER HPE = {
+0, 0, displayDebuggerHelp, displayDebuggerHelpHelp, 0, "HELP", 0, 0,
+"this help screen (type HELP <command> for specific help)" , 0 };
+
+DEBUGGER_PARSER HelpPE = {
+0, 0, displayDebuggerHelp, displayDebuggerHelpHelp, 0, "H", 0, 0,
+"this help screen" , 0 };
+
+DEBUGGER_PARSER clearScreenPE = {
+0, 0, clearDebuggerScreen, clearScreenHelp, 0, "CLS", 0, 0,
+"clear the screen" , 0 };
+
+DEBUGGER_PARSER asciiTablePE = {
+0, 0, displayASCTable, ascTableHelp, 0, "A", 0, 0,
+"display ASCII Table" , 0 };
+
+DEBUGGER_PARSER TUTogglePE = {
+0, 0, ProcessTUToggle, displayToggleHelp, 0, ".TU", 0, 0,
+"toggles unasm debug display (ON | OFF)" , 0 };
+
+DEBUGGER_PARSER TDTogglePE = {
+0, 0, ProcessTDToggle, displayToggleHelp, 0, ".TD", 0, 0,
+"toggles full dereference display (ON | OFF)" , 0 };
+
+DEBUGGER_PARSER TLTogglePE = {
+0, 0, ProcessTLToggle, displayToggleHelp, 0, ".TL", 0, 0,
+"toggles source line display (ON | OFF)" , 0 };
+
+DEBUGGER_PARSER TGTogglePE = {
+0, 0, ProcessTGToggle, displayToggleHelp, 0, ".TG", 0, 0,
+"toggles general registers (ON | OFF)" , 0 };
+
+DEBUGGER_PARSER TCTogglePE = {
+0, 0, ProcessTCToggle, displayToggleHelp, 0, ".TC", 0, 0,
+"toggles control registers (ON | OFF)" , 0 };
+
+DEBUGGER_PARSER TNTogglePE = {
+0, 0, ProcessTNToggle, displayToggleHelp, 0, ".TN", 0, 0,
+"toggles coprocessor registers (ON | OFF)"  , 0 };
+
+DEBUGGER_PARSER TRTogglePE = {
+0, 0, ProcessTRToggle, displayToggleHelp, 0, ".TR", 0, 0,
+"toggles display of break reason (ON | OFF)"  , 0 };
+
+DEBUGGER_PARSER TSTogglePE = {
+0, 0, ProcessTSToggle, displayToggleHelp, 0, ".TS", 0, 0,
+"toggles segment registers (ON | OFF)"  , 0 };
+
+DEBUGGER_PARSER TATogglePE = {
+0, 0, ProcessTAToggle, displayToggleHelp, 0, ".TA", 0, 0,
+"toggles all registers (ON | OFF)" , 0 };
+
+DEBUGGER_PARSER ReasonPE = {
+0, 0, ReasonDisplay, ReasonHelp, 0, ".A", 0, 0,
+"display break reason" , 0 };
+
+DEBUGGER_PARSER TTogglePE = {
+0, 0, TSSDisplay, TSSDisplayHelp, 0, ".T", 0, 0,
+"display task state segment (tss)" , 0 };
+
+DEBUGGER_PARSER versionPE = {
+0, 0, DisplayDebuggerVersion, displayDebuggerVersionHelp, 0, ".V", 0, 0,
+"display version info" , 0 };
+
+#if defined(CONFIG_MODULES)
+DEBUGGER_PARSER lsmodPE1 = {
+0, 0, listModules, listModulesHelp, 0, ".M", 0, 0,
+"list loaded modules" , 0 };
+
+DEBUGGER_PARSER lsmodPE2 = {
+0, 0, listModules, listModulesHelp, 0, "LSMOD", 0, 0,
+"list loaded modules" , 0 };
+
+DEBUGGER_PARSER rmmodPE = {
+0, 0, unloadModule, listModulesHelp, 0, "RMMOD", 0, 0,
+"unload module" , 0 };
+#endif
+
+DEBUGGER_PARSER rebootPE = {
+0, 0, rebootSystem, rebootSystemHelp, 0, "REBOOT", 0, 0,
+"reboot host system" , 0 };
+
+DEBUGGER_PARSER KernelProcessPE1 = {
+0, 0, displayKernelProcess, displayKernelProcessHelp, 0, ".P", 0, 0,
+"display kernel processes" , 0 };
+
+DEBUGGER_PARSER KernelProcessPE2 = {
+0, 0, displayKernelProcess, displayKernelProcessHelp, 0, "PS", 0, 0,
+"display kernel processes" , 0 };
+
+/*
+DEBUGGER_PARSER SectionPE1 = {
+0, 0, displaySections, displaySectionsHelp, 0, ".S", 0, 0,
+"display kernel/module sections" , 0 };
+
+DEBUGGER_PARSER SectionPE2 = {
+0, 0, displaySections, displaySectionsHelp, 0, "SECTIONS", 0, 0,
+"display kernel/module sections" , 0 };
+*/
+
+DEBUGGER_PARSER AllSymbolsPE = {
+0, 0, displaySymbols, displaySymbolsHelp, 0, "SYMBOL", 0, 0,
+"display symbol(s)" , 0 };
+
+DEBUGGER_PARSER SymbolsPE = {
+0, 0, displaySymbols, displaySymbolsHelp, 0, ".Z", 0, 0,
+"display symbol(s)" , 0 };
+
+DEBUGGER_PARSER ControlPE = {
+0, 0, displayControlRegisters, displayRegistersHelp, 0, "RC", 0, 0,
+"display control registers" , 0 };
+
+DEBUGGER_PARSER AllPE = {
+0, 0, displayAllRegisters, displayRegistersHelp, 0, "RA", 0, 0,
+"display all registers" , 0 };
+
+DEBUGGER_PARSER SegmentPE = {
+0, 0, displaySegmentRegisters, displayRegistersHelp, 0, "RS", 0, 0,
+"display segment registers" , 0 };
+
+DEBUGGER_PARSER NumericPE = {
+0, 0, displayNumericRegisters, displayRegistersHelp, 0, "RN", 0, 0,
+"display coprocessor/MMX registers" , 0 };
+
+DEBUGGER_PARSER GeneralPE = {
+0, 0, displayGeneralRegisters, displayRegistersHelp, 0, "RG", 0, 0,
+"display general registers" , 0 };
+
+DEBUGGER_PARSER DefaultPE = {
+0, 0, displayDefaultRegisters, displayRegistersHelp, 0, "R", 0, 0,
+"display registers for a processor" , 0 };
+
+DEBUGGER_PARSER SearchMemoryBPE = {
+0, 0, SearchMemoryB, SearchMemoryHelp, 0, "SB", 0, 0,
+"search memory for pattern (bytes)"  , 0 };
+
+DEBUGGER_PARSER SearchMemoryWPE = {
+0, 0, SearchMemoryW, SearchMemoryHelp, 0, "SW", 0, 0,
+"search memory for pattern (words)"  , 0 };
+
+DEBUGGER_PARSER SearchMemoryDPE = {
+0, 0, SearchMemoryD, SearchMemoryHelp, 0, "SD", 0, 0,
+"search memory for pattern (dwords)"  , 0 };
+
+DEBUGGER_PARSER ChangeWordPE = {
+0, 0, changeWordValue, changeMemoryHelp, 0, "CW", 0, 0,
+"change words at address"  , 0 };
+
+DEBUGGER_PARSER ChangeDoublePE = {
+0, 0, changeDoubleValue, changeMemoryHelp, 0, "CD", 0, 0,
+"change dwords at address"  , 0 };
+
+DEBUGGER_PARSER ChangeBytePE = {
+0, 0, changeByteValue, changeMemoryHelp, 0, "CB", 0, 0,
+"change bytes at address"  , 0 };
+
+DEBUGGER_PARSER ChangeDefaultPE = {
+0, 0, changeDefaultValue, changeMemoryHelp, 0, "C", 0, 0,
+"change bytes at address"  , 0 };
+
+DEBUGGER_PARSER CloseSymbolsPE = {
+0, 0, displayCloseSymbols, displayCloseHelp, 0, "?", 0, 0,
+"display closest symbols to <address>" , 0 };
+
+DEBUGGER_PARSER WalkPE = {
+0, 0, debuggerWalkStack, displayDumpHelp, 0, "W", 0, 0,
+"display symbols on the stack"  , 0 };
+
+DEBUGGER_PARSER DumpLinkedPE = {
+0, 0, debuggerDumpLinkedList, displayDumpHelp, 0, "DL", 0, 0,
+"dump linked list"  , 0 };
+
+DEBUGGER_PARSER DumpWordPE = {
+0, 0, debuggerDumpWord, displayDumpHelp, 0, "DW", 0, 0,
+"dump memory as words"  , 0 };
+
+DEBUGGER_PARSER DumpStackPE = {
+0, 0, debuggerDumpStack, displayDumpHelp, 0, "DS", 0, 0,
+"dump stack"  , 0 };
+
+DEBUGGER_PARSER DumpDoubleStackPE = {
+0, 0, debuggerDumpDoubleStack, displayDumpHelp, 0, "DDS", 0, 0,
+"dump stack double word"  , 0 };
+
+DEBUGGER_PARSER DumpDoublePE = {
+0, 0, debuggerDumpDouble, displayDumpHelp, 0, "DD", 0, 0,
+"dump memory as double words" , 0 };
+
+DEBUGGER_PARSER DumpBytePE = {
+0, 0, debuggerDumpByte, displayDumpHelp, 0, "DB", 0, 0,
+"dump memory as bytes"  , 0 };
+
+DEBUGGER_PARSER DumpDefaultPE = {
+0, 0, debuggerDumpByte, displayDumpHelp, 0, "D", 0, 0,
+"dump memory as bytes"  , 0 };
+
+DEBUGGER_PARSER Diss16PE = {
+0, 0, processDisassemble16, displayDisassembleHelp, 0, "UU", 0, 0,
+"unassemble code (16-bit)" , 0 };
+
+DEBUGGER_PARSER Diss32PE = {
+0, 0, processDisassemble32, displayDisassembleHelp, 0, "U", 0, 0,
+"unassemble code (32-bit)"  , 0 };
+
+DEBUGGER_PARSER Id32PE = {
+0, 0, processDisassemble32, displayDisassembleHelp, 0, "ID", 0, 0,
+"unassemble code (32-bit)"  , 0 };
+
+DEBUGGER_PARSER ProceedPE = {
+0, 0, processProceed, executeCommandHelp, 0, "P", 0, 0,
+"proceed"  , -1 };
+
+DEBUGGER_PARSER TracePE = {
+0, 0, processTrace, executeCommandHelp, 0, "T", 0, 0,
+"trace"  , -1 };
+
+DEBUGGER_PARSER SingleStepPE = {
+0, 0, processTrace, executeCommandHelp, 0, "S", 0, 0,
+"single step"  , -1 };
+
+DEBUGGER_PARSER TraceSSPE = {
+0, 0, processTrace, executeCommandHelp, 0, "SS", 0, 0,
+"single step"  , -1 };
+
+DEBUGGER_PARSER TraceSSBPE = {
+0, 0, processTraceSSB, executeCommandHelp, 0, "SSB", 0, 0,
+"single step til branch", -1 };
+
+DEBUGGER_PARSER GPE = {
+0, 0, processGo, executeCommandHelp, 0, "G", 0, 0,
+"g or g til <address> match"  , -1 };
+
+DEBUGGER_PARSER GoPE = {
+0, 0, processGo, executeCommandHelp, 0, "GO", 0, 0,
+"go or go til <address> match"  , -1 };
+
+DEBUGGER_PARSER QPE = {
+0, 0, processGo, executeCommandHelp, 0, "Q", 0, 0,
+"quit debugger until <address> match"  , -1 };
+
+DEBUGGER_PARSER XPE = {
+0, 0, processGo, executeCommandHelp, 0, "X", 0, 0,
+"exit debugger until <address> match"  , -1 };
+
+DEBUGGER_PARSER BreakProcessorPE = {
+0, 0, breakProcessor, processorCommandHelp, 0, "CPU", 0, 0,
+"switch processor"  , -1 };
+
+DEBUGGER_PARSER ListProcessorsPE = {
+0, 0, listProcessors, processorCommandHelp, 0, "LCPU", 0, 0,
+"list processors"  , 0 };
+
+DEBUGGER_PARSER EAXPE = {
+0, 0, ChangeEAXRegister, displayEAXHelp, 0, "EAX", 0, -1,
+"", 0 };
+
+DEBUGGER_PARSER ORIGEAXPE = {
+0, 0, ChangeORIGEAXRegister, displayEAXHelp, 0, "ORGEAX", 0, -1,
+"", 0 };
+
+DEBUGGER_PARSER EBXPE = {
+0, 0, ChangeEBXRegister, displayEBXHelp, 0, "EBX", 0, -1,
+"", 0 };
+
+DEBUGGER_PARSER ECXPE = {
+0, 0, ChangeECXRegister, displayECXHelp, 0, "ECX", 0, -1,
+"", 0 };
+
+DEBUGGER_PARSER EDXPE = {
+0, 0, ChangeEDXRegister, displayEDXHelp, 0, "EDX", 0, -1,
+"", 0 };
+
+DEBUGGER_PARSER ESIPE = {
+0, 0, ChangeESIRegister, displayESIHelp, 0, "ESI", 0, -1,
+"", 0 };
+
+DEBUGGER_PARSER EDIPE = {
+0, 0, ChangeEDIRegister, displayEDIHelp, 0, "EDI", 0, -1,
+"", 0 };
+
+DEBUGGER_PARSER EBPPE = {
+0, 0, ChangeEBPRegister, displayEBPHelp, 0, "EBP", 0, -1,
+"", 0 };
+
+DEBUGGER_PARSER ESPPE = {
+0, 0, ChangeESPRegister, displayESPHelp, 0, "ESP", 0, -1,
+"", 0 };
+
+DEBUGGER_PARSER EIPPE = {
+0, 0, ChangeEIPRegister, displayEIPHelp, 0, "EIP", 0, -1,
+"", 0 };
+
+DEBUGGER_PARSER CSPE = {
+0, 0, ChangeCSRegister, displayCSHelp, 0, "XCS", 0, -1,
+"", 0 };
+
+DEBUGGER_PARSER DSPE = {
+0, 0, ChangeDSRegister, displayDSHelp, 0, "XDS", 0, -1,
+"", 0 };
+
+DEBUGGER_PARSER ESPE = {
+0, 0, ChangeESRegister, displayESHelp, 0, "XES", 0, -1,
+"", 0 };
+
+DEBUGGER_PARSER FSPE = {
+0, 0, ChangeFSRegister, displayFSHelp, 0, "XFS", 0, -1,
+"", 0 };
+
+DEBUGGER_PARSER GSPE = {
+0, 0, ChangeGSRegister, displayGSHelp, 0, "XGS", 0, -1,
+"", 0 };
+
+DEBUGGER_PARSER SSPE = {
+0, 0, ChangeSSRegister, displaySSHelp, 0, "XSS", 0, -1,
+"", 0 };
+
+DEBUGGER_PARSER RFPE = {
+0, 0, ChangeRFFlag, displayRFHelp, 0, "RF", 0, -1,
+"", 0 };
+
+DEBUGGER_PARSER TFPE = {
+0, 0, ChangeTFFlag, displayTFHelp, 0, "TF", 0, -1,
+"", 0 };
+
+DEBUGGER_PARSER ZFPE = {
+0, 0, ChangeZFFlag, displayZFHelp, 0, "ZF", 0, -1,
+"", 0 };
+
+DEBUGGER_PARSER SFPE = {
+0, 0, ChangeSFFlag, displaySFHelp, 0, "SF", 0, -1,
+"", 0 };
+
+DEBUGGER_PARSER PFPE = {
+0, 0, ChangePFFlag, displayPFHelp, 0, "PF", 0, -1,
+"", 0 };
+
+DEBUGGER_PARSER CFPE = {
+0, 0, ChangeCFFlag, displayCFHelp, 0, "CF", 0, -1,
+"", 0 };
+
+DEBUGGER_PARSER OFPE = {
+0, 0, ChangeOFFlag, displayOFHelp, 0, "OF", 0, -1,
+"", 0 };
+
+DEBUGGER_PARSER IFPE = {
+0, 0, ChangeIFFlag, displayIFHelp, 0, "IF", 0, -1,
+"", 0 };
+
+DEBUGGER_PARSER IDPE = {
+0, 0, ChangeIDFlag, displayIDHelp, 0, "CPUID", 0, -1,
+"", 0 };
+
+DEBUGGER_PARSER DFPE = {
+0, 0, ChangeDFFlag, displayDFHelp, 0, "DF", 0, -1,
+"", 0 };
+
+DEBUGGER_PARSER NTPE = {
+0, 0, ChangeNTFlag, displayNTHelp, 0, "NT", 0, -1,
+"", 0 };
+
+DEBUGGER_PARSER VMPE = {
+0, 0, ChangeVMFlag, displayVMHelp, 0, "VM", 0, -1,
+"", 0 };
+
+DEBUGGER_PARSER VIFPE = {
+0, 0, ChangeVIFFlag, displayVIFHelp, 0, "VIF", 0, -1,
+"", 0 };
+
+DEBUGGER_PARSER VIPPE = {
+0, 0, ChangeVIPFlag, displayVIPHelp, 0, "VIP", 0, -1,
+"", 0 };
+
+DEBUGGER_PARSER AFPE = {
+0, 0, ChangeAFFlag, displayAFHelp, 0, "AF", 0, -1,
+"", 0 };
+
+DEBUGGER_PARSER ACPE = {
+0, 0, ChangeACFlag, displayACHelp, 0, "AC", 0, -1,
+"", 0 };
+
+DEBUGGER_PARSER MTRRPE = {
+0, 0, DisplayMTRRRegisters, displayMTRRHelp, 0, "MTRR", 0, 0,
+"display memory type range registers" , 0 };
+
+DEBUGGER_PARSER GDTPE = {
+0, 0, displayGDT, displayGDTHelp, 0, ".G", 0, 0,
+"display global descriptor table" , 0 };
+
+DEBUGGER_PARSER IDTPE = {
+0, 0, displayIDT, displayIDTHelp, 0, ".I", 0, 0,
+"display interrupt descriptor table"  , 0 };
+
+DEBUGGER_PARSER EvaluatePE = {
+0, 0, evaluateExpression, evaluateExpressionHelp, 0, ".E", 0, 0,
+"evaluate expression (help .e)"  , 0 };
+
+DEBUGGER_PARSER InputWordPE = {
+0, 0, inputWordPort, portCommandHelp, 0, "IW", 0, 0,
+"input word from port" , 0 };
+
+DEBUGGER_PARSER InputDoublePE = {
+0, 0, inputDoublePort, portCommandHelp, 0, "IL", 0, 0,
+"input double word from port" , 0 };
+
+DEBUGGER_PARSER InputBytePE = {
+0, 0, inputBytePort, portCommandHelp, 0, "IB", 0, 0,
+"input byte from port" , 0 };
+
+DEBUGGER_PARSER InputPE = {
+0, 0, inputPort, portCommandHelp, 0, "I", 0, 0,
+"input byte from port" , 0 };
+
+DEBUGGER_PARSER OutputWordPE = {
+0, 0, outputWordPort, portCommandHelp, 0, "OW", 0, 0,
+"output word to port" , 0 };
+
+DEBUGGER_PARSER OutputDoublePE = {
+0, 0, outputDoublePort, portCommandHelp, 0, "OL", 0, 0,
+"output double word to port" , 0 };
+
+DEBUGGER_PARSER OutputBytePE = {
+0, 0, outputBytePort, portCommandHelp, 0, "OB", 0, 0,
+"output byte to port" , 0 };
+
+DEBUGGER_PARSER OutputPE = {
+0, 0, outputPort, portCommandHelp, 0, "O", 0, 0,
+"output byte to port" , 0 };
+
+DEBUGGER_PARSER BreakClearAllPE = {
+0, 0, breakpointClearAll, breakpointCommandHelp, 0, "BCA", 0, 0,
+"clear all breakpoints" , 0 };
+
+DEBUGGER_PARSER BreakClearPE = {
+0, 0, breakpointClear, breakpointCommandHelp, 0, "BC", 0, 0,
+"clear breakpoint" , 0 };
+
+DEBUGGER_PARSER BreakMaskPE = {
+0, 0, breakpointMask, breakpointCommandHelp, 0, "BM", 0, 0,
+"mask breaks for specific processor" , 0 };
+
+DEBUGGER_PARSER BW1PE = {
+0, 0, breakpointWord1, breakpointCommandHelp, 0, "BW1", 0, -1,
+"" , 0 };
+
+DEBUGGER_PARSER BW2PE = {
+0, 0, breakpointWord2, breakpointCommandHelp, 0, "BW2", 0, -1,
+"" , 0 };
+
+DEBUGGER_PARSER BW4PE = {
+0, 0, breakpointWord4, breakpointCommandHelp, 0, "BW4", 0, -1,
+"" , 0 };
+
+DEBUGGER_PARSER BWPE = {
+0, 0, breakpointWord, breakpointCommandHelp, 0, "BW", 0, 0,
+"set write only breakpoint #=1,2 or 4 byte len" , 0 };
+
+DEBUGGER_PARSER BR1PE = {
+0, 0, breakpointRead1, breakpointCommandHelp, 0, "BR1", 0, -1,
+"", 0 };
+
+DEBUGGER_PARSER BR2PE = {
+0, 0, breakpointRead2, breakpointCommandHelp, 0, "BR2", 0, -1,
+"", 0 };
+
+DEBUGGER_PARSER BR4PE = {
+0, 0, breakpointRead4, breakpointCommandHelp, 0, "BR4", 0, -1,
+"", 0 };
+
+DEBUGGER_PARSER BRPE = {
+0, 0, breakpointRead, breakpointCommandHelp, 0, "BR", 0, 0,
+"set read/write breakpoint #=1,2 or 4 byte len" , 0 };
+
+DEBUGGER_PARSER BI1PE = {
+0, 0, breakpointIO1, breakpointCommandHelp, 0, "BI1", 0, -1,
+"", 0 };
+
+DEBUGGER_PARSER BI2PE = {
+0, 0, breakpointIO2, breakpointCommandHelp, 0, "BI2", 0, -1,
+"", 0 };
+
+DEBUGGER_PARSER BI4PE = {
+0, 0, breakpointIO4, breakpointCommandHelp, 0, "BI4", 0, -1,
+"", 0 };
+
+DEBUGGER_PARSER BIPE = {
+0, 0, breakpointIO, breakpointCommandHelp, 0, "BI", 0, 0,
+"set io address breakpoint #=1,2 or 4 byte len"  , 0 };
+
+DEBUGGER_PARSER breakpointExecutePE = {
+0, 0, breakpointExecute, breakpointCommandHelp, 0, "B", 0, 0,
+"display all/set execute breakpoint" , 0 };
+
+DEBUGGER_PARSER breakShowTemp = {
+0, 0, breakpointShowTemp, breakpointCommandHelp, 0, "BST", 0, 0,
+"displays temporary breakpoints (proceed/go)" , 0 };
+
+// interactive debugger accelerators
+
+ACCELERATOR traceSSBACC = {
+0, 0, processTraceSSBACC, 0, 0, K_F6, 0,
+"F6 - Trace/Single Step til Branch" };
+
+ACCELERATOR traceACC = {
+0, 0, processTraceACC, 0, 0, K_F7, 0,
+"F7 - Trace/Single Step" };
+
+ACCELERATOR proceedACC = {
+0, 0, processProceedACC, 0, 0, K_F8, 0,
+"F8 - Proceed" };
+
+ACCELERATOR goACC = {
+0, 0, processGoACC, 0, 0, K_F9, 0,
+"F9 - Go" };
+
+ACCELERATOR enterACC = { // this accelerator handles repeat command
+0, 0, enterKeyACC, 0, 0, 13, 0,   // processing
+"Enter - Execute or Repeat a Command" };
+
+volatile BYTE *lastDumpAddress = 0;
+volatile BYTE *lastLinkAddress = 0;
+volatile ULONG lastUnasmAddress = 0;
+volatile ULONG displayLength;
+volatile ULONG lastCommand = 0;
+volatile ULONG lastCommandEntry = 0;
+volatile BYTE lastDebugCommand[100] = {""};
+volatile ULONG lastDisplayLength = 0;
+volatile BYTE debugCommand[100] = {""};
+volatile ULONG nextUnasmAddress = 0;
+volatile ULONG pic1Value;
+volatile ULONG pic2Value;
+volatile ULONG BreakReserved[4];
+volatile ULONG BreakPoints[4];
+volatile ULONG BreakType[4];
+volatile ULONG BreakLength[4];
+volatile ULONG BreakTemp[4];
+volatile ULONG BreakGo[4];
+volatile ULONG BreakProceed[4];
+volatile ULONG BreakMask[MAX_PROCESSORS];
+volatile StackFrame *CurrentFrame[MAX_PROCESSORS];
+volatile ULONG NestedInterrupts[MAX_PROCESSORS];
+volatile ULONG ConditionalBreakpoint[4];
+volatile BYTE BreakCondition[4][256];
+volatile StackFrame lastStackFrame;
+volatile ULONG lastCR0 = 0;
+volatile ULONG lastCR2 = 0;
+volatile ULONG lastCR4 = 0;
+volatile ULONG CurrentDR7 = 0;
+volatile ULONG CurrentDR6[MAX_PROCESSORS];
+volatile ULONG repeatCommand = 0;
+volatile ULONG totalLines;
+volatile ULONG debuggerInitialized = 0;
+
+void MDBInitializeDebugger(void)
+{
+   register ULONG i;
+   extern void InitializeDebuggerRegisters(void);
+   extern ULONG AddAccelRoutine(ACCELERATOR *);
+
+   lastCommand = 0;
+   lastCommandEntry = 0;
+   lastDisplayLength = 0;
+
+   for (i=0; i < MAX_PROCESSORS; i++)
+   {
+      BreakMask[i] = 0;
+      ProcessorHold[i] = 0;
+      ProcessorState[i] = 0;
+      ProcessorMode[i] = 0;
+   }
+
+   for (i=0; i < 4; i++)
+   {
+      BreakReserved[i] = 0;
+      BreakPoints[i] = 0;
+      BreakType[i] = 0;
+      BreakLength[i] = 0;
+      BreakProceed[i] = 0;
+      BreakGo[i] = 0;
+      BreakTemp[i] = 0;
+      ConditionalBreakpoint[i] = 0;
+      BreakCondition[i][0] = '\0';
+   }
+
+   InitializeDebuggerRegisters();
+
+   AddDebuggerCommandParser(&ReasonPE);
+   AddDebuggerCommandParser(&backTraceAllPidPE);
+   AddDebuggerCommandParser(&backTracePidPE);
+   AddDebuggerCommandParser(&backTraceStackPE);
+   AddDebuggerCommandParser(&eFramePE);
+   AddDebuggerCommandParser(&cpuFramePE);
+   AddDebuggerCommandParser(&ProcessorPE);
+   AddDebuggerCommandParser(&HPE);
+   AddDebuggerCommandParser(&HelpPE);
+   AddDebuggerCommandParser(&clearScreenPE);
+   AddDebuggerCommandParser(&asciiTablePE);
+   AddDebuggerCommandParser(&TUTogglePE);
+   AddDebuggerCommandParser(&TDTogglePE);
+   AddDebuggerCommandParser(&TLTogglePE);
+   AddDebuggerCommandParser(&TGTogglePE);
+   AddDebuggerCommandParser(&TCTogglePE);
+   AddDebuggerCommandParser(&TNTogglePE);
+   AddDebuggerCommandParser(&TRTogglePE);
+   AddDebuggerCommandParser(&TSTogglePE);
+   AddDebuggerCommandParser(&TATogglePE);
+   AddDebuggerCommandParser(&TTogglePE);
+   AddDebuggerCommandParser(&versionPE);
+   AddDebuggerCommandParser(&rebootPE);
+   AddDebuggerCommandParser(&KernelProcessPE1);
+   AddDebuggerCommandParser(&KernelProcessPE2);
+/*
+   // section defines
+   AddDebuggerCommandParser(&SectionPE1);
+   AddDebuggerCommandParser(&SectionPE2);
+*/
+   AddDebuggerCommandParser(&AllSymbolsPE);
+   AddDebuggerCommandParser(&SymbolsPE);
+
+#if defined(CONFIG_MODULES)
+   AddDebuggerCommandParser(&lsmodPE1);
+   AddDebuggerCommandParser(&lsmodPE2);
+   AddDebuggerCommandParser(&rmmodPE);
+#endif
+
+   AddDebuggerCommandParser(&ControlPE);
+   AddDebuggerCommandParser(&AllPE);
+   AddDebuggerCommandParser(&SegmentPE);
+   AddDebuggerCommandParser(&NumericPE);
+   AddDebuggerCommandParser(&GeneralPE);
+   AddDebuggerCommandParser(&DefaultPE);
+   AddDebuggerCommandParser(&SearchMemoryBPE);
+   AddDebuggerCommandParser(&SearchMemoryWPE);
+   AddDebuggerCommandParser(&SearchMemoryDPE);
+   AddDebuggerCommandParser(&ChangeWordPE);
+   AddDebuggerCommandParser(&ChangeDoublePE);
+   AddDebuggerCommandParser(&ChangeBytePE);
+   AddDebuggerCommandParser(&ChangeDefaultPE);
+   AddDebuggerCommandParser(&CloseSymbolsPE);
+   AddDebuggerCommandParser(&WalkPE);
+   AddDebuggerCommandParser(&DumpLinkedPE);
+   AddDebuggerCommandParser(&DumpWordPE);
+   AddDebuggerCommandParser(&DumpStackPE);
+   AddDebuggerCommandParser(&DumpDoubleStackPE);
+   AddDebuggerCommandParser(&DumpDoublePE);
+   AddDebuggerCommandParser(&DumpBytePE);
+   AddDebuggerCommandParser(&DumpDefaultPE);
+   AddDebuggerCommandParser(&Diss16PE);
+   AddDebuggerCommandParser(&Diss32PE);
+   AddDebuggerCommandParser(&Id32PE);
+   AddDebuggerCommandParser(&ProceedPE);
+   AddDebuggerCommandParser(&TracePE);
+   AddDebuggerCommandParser(&SingleStepPE);
+   AddDebuggerCommandParser(&TraceSSPE);
+   AddDebuggerCommandParser(&TraceSSBPE);
+   AddDebuggerCommandParser(&GPE);
+   AddDebuggerCommandParser(&GoPE);
+   AddDebuggerCommandParser(&QPE);
+   AddDebuggerCommandParser(&XPE);
+   AddDebuggerCommandParser(&BreakProcessorPE);
+   AddDebuggerCommandParser(&ListProcessorsPE);
+   AddDebuggerCommandParser(&EAXPE);
+   AddDebuggerCommandParser(&ORIGEAXPE);
+   AddDebuggerCommandParser(&EBXPE);
+   AddDebuggerCommandParser(&ECXPE);
+   AddDebuggerCommandParser(&EDXPE);
+   AddDebuggerCommandParser(&ESIPE);
+   AddDebuggerCommandParser(&EDIPE);
+   AddDebuggerCommandParser(&EBPPE);
+   AddDebuggerCommandParser(&ESPPE);
+   AddDebuggerCommandParser(&EIPPE);
+   AddDebuggerCommandParser(&CSPE);
+   AddDebuggerCommandParser(&DSPE);
+   AddDebuggerCommandParser(&ESPE);
+   AddDebuggerCommandParser(&FSPE);
+   AddDebuggerCommandParser(&GSPE);
+   AddDebuggerCommandParser(&SSPE);
+   AddDebuggerCommandParser(&RFPE);
+   AddDebuggerCommandParser(&TFPE);
+   AddDebuggerCommandParser(&ZFPE);
+   AddDebuggerCommandParser(&SFPE);
+   AddDebuggerCommandParser(&PFPE);
+   AddDebuggerCommandParser(&CFPE);
+   AddDebuggerCommandParser(&OFPE);
+   AddDebuggerCommandParser(&IFPE);
+   AddDebuggerCommandParser(&IDPE);
+   AddDebuggerCommandParser(&DFPE);
+   AddDebuggerCommandParser(&NTPE);
+   AddDebuggerCommandParser(&VMPE);
+   AddDebuggerCommandParser(&VIFPE);
+   AddDebuggerCommandParser(&VIPPE);
+   AddDebuggerCommandParser(&AFPE);
+   AddDebuggerCommandParser(&ACPE);
+   AddDebuggerCommandParser(&MTRRPE);
+   AddDebuggerCommandParser(&GDTPE);
+   AddDebuggerCommandParser(&IDTPE);
+   AddDebuggerCommandParser(&EvaluatePE);
+   AddDebuggerCommandParser(&InputWordPE);
+   AddDebuggerCommandParser(&InputDoublePE);
+   AddDebuggerCommandParser(&InputBytePE);
+   AddDebuggerCommandParser(&InputPE);
+   AddDebuggerCommandParser(&OutputWordPE);
+   AddDebuggerCommandParser(&OutputDoublePE);
+   AddDebuggerCommandParser(&OutputBytePE);
+   AddDebuggerCommandParser(&OutputPE);
+   AddDebuggerCommandParser(&BreakClearAllPE);
+   AddDebuggerCommandParser(&BreakClearPE);
+   AddDebuggerCommandParser(&BreakMaskPE);
+   AddDebuggerCommandParser(&BW1PE);
+   AddDebuggerCommandParser(&BW2PE);
+   AddDebuggerCommandParser(&BW4PE);
+   AddDebuggerCommandParser(&BWPE);
+   AddDebuggerCommandParser(&BR1PE);
+   AddDebuggerCommandParser(&BR2PE);
+   AddDebuggerCommandParser(&BR4PE);
+   AddDebuggerCommandParser(&BRPE);
+   AddDebuggerCommandParser(&BI1PE);
+   AddDebuggerCommandParser(&BI2PE);
+   AddDebuggerCommandParser(&BI4PE);
+   AddDebuggerCommandParser(&BIPE);
+   AddDebuggerCommandParser(&breakpointExecutePE);
+
+   AddAccelRoutine(&traceSSBACC);
+   AddAccelRoutine(&traceACC);
+   AddAccelRoutine(&proceedACC);
+   AddAccelRoutine(&goACC);
+   AddAccelRoutine(&enterACC);
+
+   debuggerInitialized = TRUE;
+
+   return;
+}
+
+void MDBClearDebuggerState(void)
+{
+   extern void ClearDebuggerRegisters(void);
+
+   ClearDebuggerRegisters();
+   return;
+}
+
+
+void ClearTempBreakpoints(void)
+{
+   register ULONG i;
+
+   for (i=0; i < 4; i++)
+   {
+      if (BreakTemp[i])
+      {
+	 BreakTemp[i] = 0;
+	 BreakReserved[i] = 0;
+	 BreakPoints[i] = 0;
+	 BreakType[i] = 0;
+	 BreakLength[i] = 0;
+	 BreakGo[i] = 0;
+	 BreakProceed[i] = 0;
+      }
+   }
+   SetDebugRegisters();
+   return;
+}
+
+ULONG ValidBreakpoint(ULONG address)
+{
+
+   register ULONG i;
+
+   for (i=0; i < 4; i++)
+   {
+      if (!BreakTemp[i])
+	 if (BreakPoints[i] == address)
+	    return 1;
+   }
+   return 0;
+
+}
+
+ULONG GetIP(StackFrame *stackFrame)
+{
+    return (ULONG)(stackFrame->tEIP);
+}
+
+ULONG GetStackAddress(StackFrame *stackFrame)
+{
+    return (ULONG)(stackFrame->tESP);
+}
+
+ULONG GetStackSegment(StackFrame *stackFrame)
+{
+    return (ULONG)(stackFrame->tSS);
+}
+
+// F6
+
+ULONG processTraceSSBACC(ULONG key, void *p, ACCELERATOR *accel)
+{
+     register StackFrame *stackFrame = p;
+
+     if (key) {};
+     if (p) {};
+     if (accel) {};
+
+     DBGPrint("\n");
+     lastCommand = 'T';
+     lastCR0 = ReadCR0();
+     lastCR2 = ReadCR2();
+     lastCR4 = ReadCR4();
+     memmove((void *)&lastStackFrame, stackFrame,
+		     sizeof(StackFrame));
+
+     stackFrame->tSystemFlags |= (SINGLE_STEP | RESUME);
+     ProcessorMode[get_processor_id()] = TRUE;
+
+     return -1;
+}
+
+// F8
+
+ULONG processProceedACC(ULONG key, void *p, ACCELERATOR *accel)
+{
+     register StackFrame *stackFrame = p;
+     register ULONG i;
+
+     if (key) {};
+     if (p) {};
+     if (accel) {};
+
+     DBGPrint("\n");
+     if (needs_proceed)
+     {
+	for (i=0; i < 4; i++)
+	{
+	   if (!BreakReserved[i])
+	   {
+	      BreakReserved[i] = TRUE;
+	      BreakPoints[i] = nextUnasmAddress;
+	      BreakType[i] = BREAK_EXECUTE;
+	      BreakLength[i] = ONE_BYTE_FIELD;
+	      BreakTemp[i] = TRUE;
+	      BreakProceed[i] = TRUE;
+	      SetDebugRegisters();
+	      lastCommand = 'P';
+	      lastCR0 = ReadCR0();
+	      lastCR2 = ReadCR2();
+	      lastCR4 = ReadCR4();
+	      memmove((void *)&lastStackFrame, stackFrame,
+		      sizeof(StackFrame));
+
+	      stackFrame->tSystemFlags &= ~SINGLE_STEP;
+	      stackFrame->tSystemFlags |= RESUME;
+              ProcessorMode[get_processor_id()] = TRUE;
+
+	      return -1;
+	   }
+	}
+	DBGPrint("\nNo breakpoint available for Proceed, (single step) instead");
+     }
+     lastCommand = 'P';
+     lastCR0 = ReadCR0();
+     lastCR2 = ReadCR2();
+     lastCR4 = ReadCR4();
+     memmove((void *)&lastStackFrame, stackFrame,
+	       sizeof(StackFrame));
+
+     stackFrame->tSystemFlags |= (SINGLE_STEP | RESUME);
+     ProcessorMode[get_processor_id()] = TRUE;
+
+     return -1;
+}
+
+// F7
+
+ULONG processTraceACC(ULONG key, void *p, ACCELERATOR *accel)
+{
+     register StackFrame *stackFrame = p;
+
+     if (key) {};
+     if (p) {};
+     if (accel) {};
+
+     DBGPrint("\n");
+     lastCommand = 'T';
+     lastCR0 = ReadCR0();
+     lastCR2 = ReadCR2();
+     lastCR4 = ReadCR4();
+     memmove((void *)&lastStackFrame, stackFrame,
+		     sizeof(StackFrame));
+
+     stackFrame->tSystemFlags |= (SINGLE_STEP | RESUME);
+     ProcessorMode[get_processor_id()] = TRUE;
+
+     return -1;
+}
+
+// F9
+
+ULONG processGoACC(ULONG key, void *p, ACCELERATOR *accel)
+{
+     register StackFrame *stackFrame = p;
+
+     if (key) {};
+     if (p) {};
+     if (accel) {};
+
+     DBGPrint("\n");
+     ClearTempBreakpoints();
+     lastCommand = 'G';
+     lastCR0 = ReadCR0();
+     lastCR2 = ReadCR2();
+     lastCR4 = ReadCR4();
+     memmove((void *)&lastStackFrame, stackFrame, sizeof(StackFrame));
+
+     stackFrame->tSystemFlags &= ~SINGLE_STEP;
+     stackFrame->tSystemFlags |= RESUME;
+
+     return -1;
+
+}
+
+ULONG executeCommandHelp(BYTE *commandLine, DEBUGGER_PARSER *parser)
+{
+    if (commandLine) {}
+    if (parser) {}
+
+    DBGPrint("t                        - trace\n");
+    DBGPrint("s                        - single step\n");
+    DBGPrint("ss                       - single step\n");
+    DBGPrint("ssb                      - single step til branch\n");
+    DBGPrint("p                        - proceed\n");
+    DBGPrint("g or g <address>         - go\n");
+    DBGPrint("go or go <address>       - go\n");
+    DBGPrint("q or q <address>         - quit\n");
+    DBGPrint("x or x <address>         - exit\n");
+    DBGPrint("F7                       - trace\n");
+    DBGPrint("F8                       - proceed\n");
+    DBGPrint("F9                       - go\n");
+    DBGPrint("\n");
+    return TRUE;
+}
+
+// P
+
+ULONG processProceed(BYTE *cmd,
+		    StackFrame *stackFrame, ULONG Exception,
+		    DEBUGGER_PARSER *parser)
+{
+     register ULONG i;
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     cmd = &cmd[parser->debugCommandNameLength];
+     while (*cmd && *cmd == ' ') cmd++;
+
+     if (needs_proceed)
+     {
+	for (i=0; i < 4; i++)
+	{
+	   if (!BreakReserved[i])
+	   {
+	      BreakReserved[i] = TRUE;
+	      BreakPoints[i] = nextUnasmAddress;
+	      BreakType[i] = BREAK_EXECUTE;
+	      BreakLength[i] = ONE_BYTE_FIELD;
+	      BreakTemp[i] = TRUE;
+	      BreakProceed[i] = TRUE;
+	      SetDebugRegisters();
+	      lastCommand = 'P';
+	      lastCR0 = ReadCR0();
+	      lastCR2 = ReadCR2();
+	      lastCR4 = ReadCR4();
+	      memmove((void *)&lastStackFrame, stackFrame,
+		      sizeof(StackFrame));
+
+	      stackFrame->tSystemFlags &= ~SINGLE_STEP;
+	      stackFrame->tSystemFlags |= RESUME;
+              ProcessorMode[get_processor_id()] = TRUE;
+
+	      return -1;
+	   }
+	}
+	DBGPrint("\nNo breakpoint available for Proceed, (single step) instead");
+     }
+     lastCommand = 'P';
+     lastCR0 = ReadCR0();
+     lastCR2 = ReadCR2();
+     lastCR4 = ReadCR4();
+     memmove((void *)&lastStackFrame, stackFrame,
+	       sizeof(StackFrame));
+
+     stackFrame->tSystemFlags |= (SINGLE_STEP | RESUME);
+     ProcessorMode[get_processor_id()] = TRUE;
+
+     return -1;
+
+}
+
+// SSB
+
+ULONG processTraceSSB(BYTE *cmd,
+		      StackFrame *stackFrame, ULONG Exception,
+		      DEBUGGER_PARSER *parser)
+{
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     cmd = &cmd[parser->debugCommandNameLength];
+     while (*cmd && *cmd == ' ') cmd++;
+
+     lastCommand = 'T';
+     lastCR0 = ReadCR0();
+     lastCR2 = ReadCR2();
+     lastCR4 = ReadCR4();
+     memmove((void *)&lastStackFrame, stackFrame,
+		     sizeof(StackFrame));
+
+     stackFrame->tSystemFlags |= (SINGLE_STEP | RESUME);
+     ProcessorMode[get_processor_id()] = TRUE;
+
+     return -1;
+
+}
+
+
+// T
+
+ULONG processTrace(BYTE *cmd,
+		  StackFrame *stackFrame, ULONG Exception,
+		  DEBUGGER_PARSER *parser)
+{
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     cmd = &cmd[parser->debugCommandNameLength];
+     while (*cmd && *cmd == ' ') cmd++;
+
+     lastCommand = 'T';
+     lastCR0 = ReadCR0();
+     lastCR2 = ReadCR2();
+     lastCR4 = ReadCR4();
+     memmove((void *)&lastStackFrame, stackFrame,
+		     sizeof(StackFrame));
+
+     stackFrame->tSystemFlags |= (SINGLE_STEP | RESUME);
+     ProcessorMode[get_processor_id()] = TRUE;
+
+     return -1;
+
+}
+
+// G
+
+ULONG processGo(BYTE *cmd,
+	       StackFrame *stackFrame, ULONG Exception,
+	       DEBUGGER_PARSER *parser)
+{
+     register ULONG address;
+     ULONG valid;
+     register ULONG i;
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
+	for (i=0; i < 4; i++)
+	{
+	   if (!BreakReserved[i])
+	   {
+	      BreakReserved[i] = TRUE;
+	      BreakPoints[i] = address;
+	      BreakType[i] = BREAK_EXECUTE;
+	      BreakLength[i] = ONE_BYTE_FIELD;
+	      BreakTemp[i] = TRUE;
+	      BreakGo[i] = TRUE;
+	      SetDebugRegisters();
+	      DBGPrint("\n");
+	      lastCommand = 'G';
+	      lastCR0 = ReadCR0();
+	      lastCR2 = ReadCR2();
+	      lastCR4 = ReadCR4();
+	      memmove((void *)&lastStackFrame, stackFrame,
+			      sizeof(StackFrame));
+
+	      stackFrame->tSystemFlags &= ~SINGLE_STEP;
+	      stackFrame->tSystemFlags |= RESUME;
+
+	      return -1;
+	   }
+	}
+     }
+     else
+     {
+	ClearTempBreakpoints();
+	DBGPrint("\n");
+	lastCommand = 'G';
+	lastCR0 = ReadCR0();
+	lastCR2 = ReadCR2();
+	lastCR4 = ReadCR4();
+	memmove((void *)&lastStackFrame, stackFrame,
+			sizeof(StackFrame));
+
+	stackFrame->tSystemFlags &= ~SINGLE_STEP;
+	stackFrame->tSystemFlags |= RESUME;
+
+	return -1;
+     }
+     DBGPrint("no breakpoint available for GO\n");
+     return TRUE;
+
+}
+
+ULONG processorCommandHelp(BYTE *commandLine, DEBUGGER_PARSER *parser)
+{
+    if (commandLine) {}
+    if (parser) {}
+
+    DBGPrint("lcpu                     - list processors\n");
+    DBGPrint("cpu [p#]                 - switch processor\n");
+    DBGPrint("lr  [p#]                 - display processor registers\n");
+    return TRUE;
+}
+
+// CPU
+
+ULONG breakProcessor(BYTE *cmd,
+		     StackFrame *stackFrame, ULONG Exception,
+		     DEBUGGER_PARSER *parser)
+{
+     register ULONG cpunum, cpu = get_processor_id();
+     ULONG valid, i;
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     cmd = &cmd[parser->debugCommandNameLength];
+     while (*cmd && *cmd == ' ') cmd++;
+
+     cpunum = EvaluateExpression(stackFrame, &cmd, &valid);
+     if (valid)
+     {
+        if (cpunum == cpu)
+        {
+           DBGPrint("debugger already running on processor %d\n",
(int)cpunum);
+           return TRUE;
+        }
+
+	if ((cpunum > MAX_PROCESSORS) || !(cpu_online(cpunum)))
+        {
+	   DBGPrint("invalid processor specified\n");
+           return TRUE;
+        }
+
+        for (i=0; i < MAX_PROCESSORS; i++)
+        {
+           if (cpu_online(i))
+           {
+	      if (i == cpunum)
+              {
+	         ProcessorState[i] = PROCESSOR_SWITCH;
+                 ProcessorHold[cpu] = TRUE;
+                 break;
+              }
+	   }
+        }
+	DBGPrint("\n");
+	lastCommand = 'G';
+	lastCR0 = ReadCR0();
+	lastCR2 = ReadCR2();
+	lastCR4 = ReadCR4();
+	memmove((void *)&lastStackFrame, stackFrame,
+			   sizeof(StackFrame));
+	return -1;
+     }
+     else
+     {
+	DBGPrint("no target processor specified\n");
+        DBGPrint("Current Processor: %d\n", get_processor_id());
+        DBGPrint("Active Processors: ");
+
+        for (i=0; i < MAX_PROCESSORS; i++)
+        {
+           if (cpu_online(i))
+           {
+	      if (i)
+                 DBGPrint(", ");
+
+ 	      DBGPrint("%d", i);
+	   }
+        }
+        DBGPrint("\n");
+     }
+     return TRUE;
+
+}
+
+// LR
+
+extern volatile StackFrame CurrentStackFrame[MAX_PROCESSORS];
+
+ULONG listProcessorFrame(BYTE *cmd,
+			StackFrame *stackFrame, ULONG Exception,
+			DEBUGGER_PARSER *parser)
+{
+     ULONG valid, pnum;
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     cmd = &cmd[parser->debugCommandNameLength];
+     while (*cmd && *cmd == ' ') cmd++;
+
+     pnum = EvaluateExpression(stackFrame, &cmd, &valid);
+     if (valid && (pnum < MAX_PROCESSORS) && (cpu_online(pnum)))
+     {
+	DBGPrint("Processor Frame %d -> (%08X)\n", pnum,
+                 &CurrentStackFrame[pnum]);
+	DisplayTSS((StackFrame *)&CurrentStackFrame[pnum]);
+     }
+     else
+	DBGPrint("invalid processor frame\n");
+
+     return TRUE;
+
+}
+
+// EF
+
+ULONG dump_ef(BYTE *cmd,
+	      StackFrame *stackFrame, ULONG Exception,
+	      DEBUGGER_PARSER *parser)
+{
+     ULONG valid;
+     BYTE *addr;
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     cmd = &cmd[parser->debugCommandNameLength];
+     while (*cmd && *cmd == ' ') cmd++;
+
+     addr = (BYTE *)EvaluateExpression(stackFrame, &cmd, &valid);
+     if (valid)
+     {
+        DBGPrint("invalid frame address\n");
+     }
+     else
+     {
+        addr = (BYTE *)stackFrame->tReserved[2];
+        DBGPrint("invalid frame pointer address\n");
+     }
+     return TRUE;
+
+}
+
+// UF
+
+ULONG dump_uf(BYTE *cmd,
+	      StackFrame *stackFrame, ULONG Exception,
+	      DEBUGGER_PARSER *parser)
+{
+     ULONG valid;
+     BYTE *addr;
+     extern int mdb_dumpregs(struct pt_regs *, const char *, const char *);
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     cmd = &cmd[parser->debugCommandNameLength];
+     while (*cmd && *cmd == ' ') cmd++;
+
+     addr = (BYTE *)EvaluateExpression(stackFrame, &cmd, &valid);
+     if (valid)
+     {
+        DBGPrint("invalid frame address\n");
+     }
+     else
+     {
+        addr = (BYTE *)stackFrame->tReserved[2];
+        DBGPrint("invalid frame pointer address\n");
+     }
+     return TRUE;
+
+}
+
+// .TA
+
+ULONG ProcessTAToggle(BYTE *cmd,
+		   StackFrame *stackFrame, ULONG Exception,
+		   DEBUGGER_PARSER *parser)
+{
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     if (general_toggle)
+     {
+        general_toggle = 0;
+        control_toggle = 0;
+        segment_toggle = 0;
+     }
+     else
+     {
+        general_toggle = 1;
+        control_toggle = 1;
+        segment_toggle = 1;
+     }
+
+     DBGPrint("toggle general registers (%s) \n",
+					    general_toggle ? "ON" : "OFF");
+     DBGPrint("toggle control registers (%s) \n",
+					    control_toggle ? "ON" : "OFF");
+     DBGPrint("toggle segment registers (%s) \n",
+					    segment_toggle ? "ON" : "OFF");
+     return TRUE;
+
+}
+
+ULONG TSSDisplayHelp(BYTE *commandLine, DEBUGGER_PARSER *parser)
+{
+    if (commandLine) {}
+    if (parser) {}
+
+    DBGPrint(".t <address>             - display task state regs\n");
+    return TRUE;
+}
+
+// .T
+
+ULONG TSSDisplay(BYTE *cmd,
+		   StackFrame *stackFrame, ULONG Exception,
+		   DEBUGGER_PARSER *parser)
+{
+     register ULONG address;
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
+     if (!valid)
+	DisplayTSS(stackFrame);
+     else
+	DisplayTSS((StackFrame *) address);
+
+     return TRUE;
+}
+
+ULONG displayRegistersHelp(BYTE *commandLine, DEBUGGER_PARSER *parser)
+{
+    if (commandLine) {}
+    if (parser) {}
+
+    DBGPrint("r                        - display registers for a
processor\n");
+    DBGPrint("rc                       - display control registers \n");
+    DBGPrint("rs                       - display segment registers \n");
+    DBGPrint("rg                       - display general registers \n");
+    DBGPrint("ra                       - display all registers\n");
+    DBGPrint("rn                       - display coprocessor/MMX
registers\n");
+
+    return TRUE;
+}
+
+// RC
+
+ULONG displayControlRegisters(BYTE *cmd,
+			     StackFrame *stackFrame, ULONG Exception,
+			     DEBUGGER_PARSER *parser)
+{
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     DBGPrint("Control Registers\n");
+     DisplayControlRegisters(get_processor_id(), stackFrame);
+     return TRUE;
+
+}
+
+// RA
+
+ULONG displayAllRegisters(BYTE *cmd,
+			     StackFrame *stackFrame, ULONG Exception,
+			     DEBUGGER_PARSER *parser)
+{
+     register ULONG processor = get_processor_id();
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     DBGPrint("General Registers\n");
+     DisplayGeneralRegisters(stackFrame);
+
+     DBGPrint("Segment Registers\n");
+     DisplaySegmentRegisters(stackFrame);
+
+     DBGPrint("Control Registers\n");
+     DisplayControlRegisters(processor, stackFrame);
+
+     if (fpu_present())
+     {
+	DBGPrint("Coprocessor Registers\n");
+	DisplayNPXRegisters(processor);
+     }
+     else
+     {
+	DBGPrint("Coprocessor Not Present\n");
+     }
+     return TRUE;
+
+}
+
+
+// RS
+
+ULONG displaySegmentRegisters(BYTE *cmd,
+			     StackFrame *stackFrame, ULONG Exception,
+			     DEBUGGER_PARSER *parser)
+{
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     DBGPrint("Segment Registers\n");
+     DisplaySegmentRegisters(stackFrame);
+     return TRUE;
+
+}
+
+// RN
+
+ULONG displayNumericRegisters(BYTE *cmd,
+			     StackFrame *stackFrame, ULONG Exception,
+			     DEBUGGER_PARSER *parser)
+{
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     if (fpu_present())
+     {
+	DBGPrint("Coprocessor Registers\n");
+	DisplayNPXRegisters(get_processor_id());
+     }
+     else
+     {
+	DBGPrint("Coprocessor Not Present\n");
+     }
+     return TRUE;
+
+}
+
+// RG
+
+ULONG displayGeneralRegisters(BYTE *cmd,
+			     StackFrame *stackFrame, ULONG Exception,
+			     DEBUGGER_PARSER *parser)
+{
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     DBGPrint("General Registers\n");
+     DisplayGeneralRegisters(stackFrame);
+     return TRUE;
+
+
+}
+
+#ifdef RENDER_NPX_VALUES
+double ldexp(double v, int e)
+{
+   double two = 2.0;
+
+   if (e < 0)
+   {
+      e = -e; // This just might overflow on two-complement machines.
+      if (e < 0)
+         return 0.0;
+
+      while (e > 0)
+      {
+	 if (e & 1)
+         {
+            v = v / two;
+         }
+	 two = two * two;
+	 e >>= 1;
+      }
+   }
+   else
+   if (e > 0)
+   {
+      while (e > 0)
+      {
+	 if (e & 1)
+            v = v * two;
+	 two = two * two;
+	 e >>= 1;
+      }
+   }
+   return v;
+}
+#endif
+
+void DisplayNPXRegisters(ULONG processor)
+{
+     register int i;
+     int tag;
+     int tos;
+#ifdef RENDER_NPX_VALUES
+     double d;
+#endif
+
+     tos = (npx[processor].status >> 11) & 7;
+     if (tos) {};
+
+     DBGPrint("Control: 0x%04X  Status: 0x%04X  Tag: 0x%04X  TOS: %i CPU:
%i\n",
+	       (unsigned)npx[processor].control & 0xFFFF,
+               (unsigned)npx[processor].status & 0xFFFF,
+               (unsigned)npx[processor].tag & 0xFFFF,
+               (int)tos, (int)processor);
+
+     for (i = 0; i < 8; i++)
+     {
+	tos = (npx[processor].status >> 11) & 7;
+	DBGPrint("st(%d)/MMX%d  ", i, (int)((tos + i) % 8));
+
+	if (npx[processor].reg[i].sign)
+	    DBGPrint("-");
+	else
+	    DBGPrint("+");
+
+	DBGPrint(" %04X %04X %04X %04X e %04X    ",
+		 (unsigned)npx[processor].reg[i].sig3,
+		 (unsigned)npx[processor].reg[i].sig2,
+		 (unsigned)npx[processor].reg[i].sig1,
+		 (unsigned)npx[processor].reg[i].sig0,
+		 (unsigned)npx[processor].reg[i].exponent);
+
+	 if (tos) {};
+	 tag = (npx[processor].tag >> (((i + tos) % 8) * 2)) & 3;
+	 switch (tag)
+	 {
+
+	    case 0:
+	       DBGPrint("Valid");
+#ifdef RENDER_NPX_VALUES
+	       if (((int) npx[processor].reg[i].exponent - 16382 < 1000) &&
+		  ((int) npx[processor].reg[i].exponent - 16382 > -1000))
+	       {
+		  d =
+                  npx[processor].reg[i].sig3 / 65536.0 +
+                  npx[processor].reg[i].sig2 / 65536.0 / 65536.0 +
+                  npx[processor].reg[i].sig1 / 65536.0 / 65536.0 / 65536.0;
+
+		  d = ldexp(d, (int) npx[processor].reg[i].exponent - 16382);
+
+ 	          if (npx[processor].reg[i].sign)
+		     d = -d;
+
+		  DBGPrint("  %.16g", d);
+	       }
+	       else
+		  DBGPrint("  (too big to display)");
+#endif
+	       DBGPrint("\n");
+	       break;
+
+	    case 1:
+	       DBGPrint("Zero\n");
+	       break;
+
+	    case 2:
+	       DBGPrint("Special\n");
+	       break;
+
+	    case 3:
+	       DBGPrint("Empty\n");
+	       break;
+	}
+     }
+}
+
+// R
+
+ULONG displayDefaultRegisters(BYTE *cmd,
+			     StackFrame *stackFrame, ULONG Exception,
+			     DEBUGGER_PARSER *parser)
+{
+     register ULONG processor = get_processor_id();
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+    DisplayGeneralRegisters(stackFrame);
+
+    if (control_toggle)
+       DisplayControlRegisters(processor, stackFrame);
+
+    if (numeric_toggle)
+       DisplayNPXRegisters(processor);
+
+     disassemble(stackFrame, stackFrame->tEIP, 1, 1);
+     return TRUE;
+
+}
+
+void displayRegisters(StackFrame *stackFrame, ULONG processor)
+{
+    if (general_toggle)
+       DisplayGeneralRegisters(stackFrame);
+
+    if (control_toggle)
+       DisplayControlRegisters(processor, stackFrame);
+
+    if (numeric_toggle)
+       DisplayNPXRegisters(processor);
+
+}
+
+ULONG displayEAXHelp(BYTE *commandLine, DEBUGGER_PARSER *parser)
+{
+    if (commandLine) {}
+    if (parser) {}
+    return TRUE;
+}
+
+// EAX
+
+ULONG ChangeEAXRegister(BYTE *cmd,
+		       StackFrame *stackFrame, ULONG Exception,
+		       DEBUGGER_PARSER *parser)
+{
+     ULONG valid;
+     register ULONG value;
+
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     cmd = &cmd[parser->debugCommandNameLength];
+     while (*cmd && *cmd == ' ') cmd++;
+
+     value = EvaluateExpression(stackFrame, &cmd, &valid);
+     if (valid)
+     {
+	stackFrame->tEAX = value;
+	DBGPrint("EAX changed to 0x%08X\n", (unsigned)value);
+     }
+     else
+	DBGPrint("invalid change register command or address\n");
+     return TRUE;
+
+}
+
+
+// ORIGEAX
+
+ULONG ChangeORIGEAXRegister(BYTE *cmd,
+		       StackFrame *stackFrame, ULONG Exception,
+		       DEBUGGER_PARSER *parser)
+{
+     ULONG valid;
+     register ULONG value;
+
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     cmd = &cmd[parser->debugCommandNameLength];
+     while (*cmd && *cmd == ' ') cmd++;
+
+     value = EvaluateExpression(stackFrame, &cmd, &valid);
+     if (valid)
+     {
+	stackFrame->tReserved[1] = value;
+	DBGPrint("ORIGEAX changed to 0x%08X\n", (unsigned)value);
+     }
+     else
+	DBGPrint("invalid change register command or address\n");
+     return TRUE;
+
+}
+
+
+ULONG displayEBXHelp(BYTE *commandLine, DEBUGGER_PARSER *parser)
+{
+    if (commandLine) {}
+    if (parser) {}
+
+    return TRUE;
+}
+
+// EBX
+
+ULONG ChangeEBXRegister(BYTE *cmd,
+		       StackFrame *stackFrame, ULONG Exception,
+		       DEBUGGER_PARSER *parser)
+{
+     ULONG valid;
+     register ULONG value;
+
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     cmd = &cmd[parser->debugCommandNameLength];
+     while (*cmd && *cmd == ' ') cmd++;
+
+     value = EvaluateExpression(stackFrame, &cmd, &valid);
+     if (valid)
+     {
+	stackFrame->tEBX = value;
+	DBGPrint("EBX changed to 0x%08X\n", (unsigned)value);
+     }
+     else
+	DBGPrint("invalid change register command or address\n");
+     return TRUE;
+
+}
+
+ULONG displayECXHelp(BYTE *commandLine, DEBUGGER_PARSER *parser)
+{
+    if (commandLine) {}
+    if (parser) {}
+
+    return TRUE;
+}
+
+// ECX
+
+ULONG ChangeECXRegister(BYTE *cmd,
+		       StackFrame *stackFrame, ULONG Exception,
+		       DEBUGGER_PARSER *parser)
+{
+     ULONG valid;
+     register ULONG value;
+
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     cmd = &cmd[parser->debugCommandNameLength];
+     while (*cmd && *cmd == ' ') cmd++;
+
+     value = EvaluateExpression(stackFrame, &cmd, &valid);
+     if (valid)
+     {
+	stackFrame->tECX = value;
+	DBGPrint("ECX changed to 0x%08X\n", (unsigned)value);
+     }
+     else
+	DBGPrint("invalid change register command or address\n");
+     return TRUE;
+
+}
+
+
+ULONG displayEDXHelp(BYTE *commandLine, DEBUGGER_PARSER *parser)
+{
+    if (commandLine) {}
+    if (parser) {}
+
+    return TRUE;
+}
+
+// EDX
+
+ULONG ChangeEDXRegister(BYTE *cmd,
+		       StackFrame *stackFrame, ULONG Exception,
+		       DEBUGGER_PARSER *parser)
+{
+     ULONG valid;
+     register ULONG value;
+
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     cmd = &cmd[parser->debugCommandNameLength];
+     while (*cmd && *cmd == ' ') cmd++;
+
+     value = EvaluateExpression(stackFrame, &cmd, &valid);
+     if (valid)
+     {
+	stackFrame->tEDX = value;
+	DBGPrint("EDX changed to 0x%08X\n", (unsigned)value);
+     }
+     else
+	DBGPrint("invalid change register command or address\n");
+     return TRUE;
+
+}
+
+ULONG displayESIHelp(BYTE *commandLine, DEBUGGER_PARSER *parser)
+{
+    if (commandLine) {}
+    if (parser) {}
+
+    return TRUE;
+}
+
+// ESI
+
+ULONG ChangeESIRegister(BYTE *cmd,
+		       StackFrame *stackFrame, ULONG Exception,
+		       DEBUGGER_PARSER *parser)
+{
+     ULONG valid;
+     register ULONG value;
+
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     cmd = &cmd[parser->debugCommandNameLength];
+     while (*cmd && *cmd == ' ') cmd++;
+
+     value = EvaluateExpression(stackFrame, &cmd, &valid);
+     if (valid)
+     {
+	stackFrame->tESI = value;
+	DBGPrint("ESI changed to 0x%08X\n", (unsigned)value);
+     }
+     else
+	DBGPrint("invalid change register command or address\n");
+     return TRUE;
+
+}
+
+
+ULONG displayEDIHelp(BYTE *commandLine, DEBUGGER_PARSER *parser)
+{
+    if (commandLine) {}
+    if (parser) {}
+
+    return TRUE;
+}
+
+// EDI
+
+ULONG ChangeEDIRegister(BYTE *cmd,
+		       StackFrame *stackFrame, ULONG Exception,
+		       DEBUGGER_PARSER *parser)
+{
+     ULONG valid;
+     register ULONG value;
+
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     cmd = &cmd[parser->debugCommandNameLength];
+     while (*cmd && *cmd == ' ') cmd++;
+
+     value = EvaluateExpression(stackFrame, &cmd, &valid);
+     if (valid)
+     {
+	stackFrame->tEDI = value;
+	DBGPrint("EDI changed to 0x%08X\n", (unsigned)value);
+     }
+     else
+	DBGPrint("invalid change register command or address\n");
+     return TRUE;
+
+}
+
+
+ULONG displayEBPHelp(BYTE *commandLine, DEBUGGER_PARSER *parser)
+{
+    if (commandLine) {}
+    if (parser) {}
+
+    return TRUE;
+}
+
+// EBP
+
+ULONG ChangeEBPRegister(BYTE *cmd,
+	       StackFrame *stackFrame, ULONG Exception,
+	       DEBUGGER_PARSER *parser)
+{
+     ULONG valid;
+     register ULONG value;
+
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     cmd = &cmd[parser->debugCommandNameLength];
+     while (*cmd && *cmd == ' ') cmd++;
+
+     value = EvaluateExpression(stackFrame, &cmd, &valid);
+     if (valid)
+     {
+	stackFrame->tEBP = value;
+	DBGPrint("EBP changed to 0x%08X\n", (unsigned)value);
+     }
+     else
+	DBGPrint("invalid change register command or address\n");
+     return TRUE;
+
+}
+
+
+ULONG displayESPHelp(BYTE *commandLine, DEBUGGER_PARSER *parser)
+{
+    if (commandLine) {}
+    if (parser) {}
+
+    return TRUE;
+}
+
+// ESP
+
+ULONG ChangeESPRegister(BYTE *cmd,
+		       StackFrame *stackFrame, ULONG Exception,
+		       DEBUGGER_PARSER *parser)
+{
+     ULONG valid;
+     register ULONG value;
+
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     cmd = &cmd[parser->debugCommandNameLength];
+     while (*cmd && *cmd == ' ') cmd++;
+
+     value = EvaluateExpression(stackFrame, &cmd, &valid);
+     if (valid)
+     {
+	stackFrame->tESP = value;
+	DBGPrint("ESP changed to 0x%08X\n", (unsigned)value);
+     }
+     else
+	DBGPrint("invalid change register command or address\n");
+     return TRUE;
+
+}
+
+
+ULONG displayEIPHelp(BYTE *commandLine, DEBUGGER_PARSER *parser)
+{
+    if (commandLine) {}
+    if (parser) {}
+
+    return TRUE;
+}
+
+// EIP
+
+ULONG ChangeEIPRegister(BYTE *cmd,
+		       StackFrame *stackFrame, ULONG Exception,
+		       DEBUGGER_PARSER *parser)
+{
+     ULONG valid;
+     register ULONG value;
+
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     cmd = &cmd[parser->debugCommandNameLength];
+     while (*cmd && *cmd == ' ') cmd++;
+
+     value = EvaluateExpression(stackFrame, &cmd, &valid);
+     if (valid)
+     {
+	stackFrame->tEIP = value;
+	DBGPrint("EIP changed to 0x%08X\n", (unsigned)value);
+     }
+     else
+	DBGPrint("invalid change register command or address\n");
+     return TRUE;
+
+}
+
+ULONG displayCSHelp(BYTE *commandLine, DEBUGGER_PARSER *parser)
+{
+    if (commandLine) {}
+    if (parser) {}
+
+    return TRUE;
+}
+
+// CS
+
+ULONG ChangeCSRegister(BYTE *cmd,
+		      StackFrame *stackFrame, ULONG Exception,
+		      DEBUGGER_PARSER *parser)
+{
+     ULONG valid;
+     register ULONG value;
+     register WORD oldW;
+
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     cmd = &cmd[parser->debugCommandNameLength];
+     while (*cmd && *cmd == ' ') cmd++;
+
+     value = EvaluateExpression(stackFrame, &cmd, &valid);
+     if (valid)
+     {
+	oldW = stackFrame->tCS;
+	stackFrame->tCS = (WORD) value;
+	DBGPrint("CS: = [%04X] changed to CS: = [%04X]\n",
+			(unsigned)oldW, (unsigned) value);
+     }
+     else
+	DBGPrint("invalid change segment register command or address\n");
+     return TRUE;
+
+}
+
+ULONG displayDSHelp(BYTE *commandLine, DEBUGGER_PARSER *parser)
+{
+    if (commandLine) {}
+    if (parser) {}
+
+    return TRUE;
+}
+
+// DS
+
+ULONG ChangeDSRegister(BYTE *cmd,
+		      StackFrame *stackFrame, ULONG Exception,
+		      DEBUGGER_PARSER *parser)
+{
+     ULONG valid;
+     register ULONG value;
+     register WORD oldW;
+
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     cmd = &cmd[parser->debugCommandNameLength];
+     while (*cmd && *cmd == ' ') cmd++;
+
+     value = EvaluateExpression(stackFrame, &cmd, &valid);
+     if (valid)
+     {
+	oldW = stackFrame->tDS;
+	stackFrame->tDS = (WORD) value;
+	DBGPrint("DS: = [%04X] changed to DS: = [%04X]\n",
+			(unsigned)oldW, (unsigned)value);
+     }
+     else
+	DBGPrint("invalid change segment register command or address\n");
+     return TRUE;
+
+}
+
+ULONG displayESHelp(BYTE *commandLine, DEBUGGER_PARSER *parser)
+{
+    if (commandLine) {}
+    if (parser) {}
+
+    return TRUE;
+}
+
+// ES
+
+ULONG ChangeESRegister(BYTE *cmd,
+		      StackFrame *stackFrame, ULONG Exception,
+		      DEBUGGER_PARSER *parser)
+{
+     ULONG valid;
+     register ULONG value;
+     register WORD oldW;
+
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     cmd = &cmd[parser->debugCommandNameLength];
+     while (*cmd && *cmd == ' ') cmd++;
+
+     value = EvaluateExpression(stackFrame, &cmd, &valid);
+     if (valid)
+     {
+	oldW = stackFrame->tES;
+	stackFrame->tES = (WORD) value;
+	DBGPrint("ES: = [%04X] changed to ES: = [%04X]\n",
+			(unsigned)oldW, (unsigned) value);
+     }
+     else
+	DBGPrint("invalid change segment register command or address\n");
+     return TRUE;
+
+}
+
+ULONG displayFSHelp(BYTE *commandLine, DEBUGGER_PARSER *parser)
+{
+    if (commandLine) {}
+    if (parser) {}
+
+    return TRUE;
+}
+
+// FS
+
+ULONG ChangeFSRegister(BYTE *cmd,
+		      StackFrame *stackFrame, ULONG Exception,
+		      DEBUGGER_PARSER *parser)
+{
+     ULONG valid;
+     register ULONG value;
+     register WORD oldW;
+
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     cmd = &cmd[parser->debugCommandNameLength];
+     while (*cmd && *cmd == ' ') cmd++;
+
+     value = EvaluateExpression(stackFrame, &cmd, &valid);
+     if (valid)
+     {
+	oldW = stackFrame->tFS;
+	stackFrame->tFS = (WORD) value;
+	DBGPrint("FS: = [%04X] changed to FS: = [%04X]\n",
+			(unsigned)oldW, (unsigned)value);
+     }
+     else
+	DBGPrint("invalid change segment register command or address\n");
+     return TRUE;
+
+}
+
+ULONG displayGSHelp(BYTE *commandLine, DEBUGGER_PARSER *parser)
+{
+    if (commandLine) {}
+    if (parser) {}
+
+    return TRUE;
+}
+
+// GS
+
+ULONG ChangeGSRegister(BYTE *cmd,
+		      StackFrame *stackFrame, ULONG Exception,
+		      DEBUGGER_PARSER *parser)
+{
+     ULONG valid;
+     register ULONG value;
+     register WORD oldW;
+
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     cmd = &cmd[parser->debugCommandNameLength];
+     while (*cmd && *cmd == ' ') cmd++;
+
+     value = EvaluateExpression(stackFrame, &cmd, &valid);
+     if (valid)
+     {
+	oldW = stackFrame->tGS;
+	stackFrame->tGS = (WORD) value;
+	DBGPrint("GS: = [%04X] changed to GS: = [%04X]\n",
+			(unsigned)oldW, (unsigned)value);
+     }
+     else
+	DBGPrint("invalid change segment register command or address\n");
+     return TRUE;
+
+}
+
+ULONG displaySSHelp(BYTE *commandLine, DEBUGGER_PARSER *parser)
+{
+    if (commandLine) {}
+    if (parser) {}
+
+    return TRUE;
+}
+
+// SS
+
+ULONG ChangeSSRegister(BYTE *cmd,
+		      StackFrame *stackFrame, ULONG Exception,
+		      DEBUGGER_PARSER *parser)
+{
+     ULONG valid;
+     register ULONG value;
+     register WORD oldW;
+
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     cmd = &cmd[parser->debugCommandNameLength];
+     while (*cmd && *cmd == ' ') cmd++;
+
+     value = EvaluateExpression(stackFrame, &cmd, &valid);
+     if (valid)
+     {
+	oldW = stackFrame->tSS;
+	stackFrame->tSS = (WORD) value;
+	DBGPrint("SS: = [%04X] changed to SS: = [%04X]\n",
+			(unsigned)oldW, (unsigned)value);
+     }
+     else
+	DBGPrint("invalid change segment register command or address\n");
+
+     return TRUE;
+
+}
+
+ULONG displayRFHelp(BYTE *commandLine, DEBUGGER_PARSER *parser)
+{
+    if (commandLine) {}
+    if (parser) {}
+
+    return TRUE;
+}
+
+// RF
+
+ULONG ChangeRFFlag(BYTE *cmd,
+		  StackFrame *stackFrame, ULONG Exception,
+		  DEBUGGER_PARSER *parser)
+{
+     ULONG valid;
+     register ULONG value, oldD;
+
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     cmd = &cmd[parser->debugCommandNameLength];
+     while (*cmd && *cmd == ' ') cmd++;
+
+     value = EvaluateExpression(stackFrame, &cmd, &valid);
+     if (valid)
+     {
+	oldD = stackFrame->tSystemFlags & RF_FLAG;
+	(value) ? (stackFrame->tSystemFlags |= RF_FLAG) :
(stackFrame->tSystemFlags &= ~RF_FLAG);
+	DBGPrint("EFlag RF[%08X] changed to (%d)\n",
+			(unsigned)oldD, (int)value);
+     }
+     else
+	DBGPrint("invalid change flags command\n");
+     return TRUE;
+
+}
+
+ULONG displayTFHelp(BYTE *commandLine, DEBUGGER_PARSER *parser)
+{
+    if (commandLine) {}
+    if (parser) {}
+
+    return TRUE;
+}
+
+// TF
+
+ULONG ChangeTFFlag(BYTE *cmd,
+		  StackFrame *stackFrame, ULONG Exception,
+		  DEBUGGER_PARSER *parser)
+{
+     ULONG valid;
+     register ULONG value, oldD;
+
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     cmd = &cmd[parser->debugCommandNameLength];
+     while (*cmd && *cmd == ' ') cmd++;
+
+     value = EvaluateExpression(stackFrame, &cmd, &valid);
+     if (valid)
+     {
+	oldD = stackFrame->tSystemFlags & TF_FLAG;
+	(value) ? (stackFrame->tSystemFlags |= TF_FLAG) :
(stackFrame->tSystemFlags &= ~TF_FLAG);
+	DBGPrint("EFlag TF[%08X] changed to (%d)\n",
+			(unsigned)oldD, (int)value);
+     }
+     else
+	DBGPrint("invalid change flags command\n");
+     return TRUE;
+
+}
+
+ULONG displayZFHelp(BYTE *commandLine, DEBUGGER_PARSER *parser)
+{
+    if (commandLine) {}
+    if (parser) {}
+
+    return TRUE;
+}
+
+// ZF
+
+ULONG ChangeZFFlag(BYTE *cmd,
+		  StackFrame *stackFrame, ULONG Exception,
+		  DEBUGGER_PARSER *parser)
+{
+     ULONG valid;
+     register ULONG value, oldD;
+
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     cmd = &cmd[parser->debugCommandNameLength];
+     while (*cmd && *cmd == ' ') cmd++;
+
+     value = EvaluateExpression(stackFrame, &cmd, &valid);
+     if (valid)
+     {
+	oldD = stackFrame->tSystemFlags & ZF_FLAG;
+	(value) ? (stackFrame->tSystemFlags |= ZF_FLAG) :
(stackFrame->tSystemFlags &= ~ZF_FLAG);
+	DBGPrint("EFlag ZF[%08X] changed to (%d)\n",
+				(unsigned)oldD, (int)value);
+     }
+     else
+	DBGPrint("invalid change flags command\n");
+     return TRUE;
+
+}
+
+ULONG displaySFHelp(BYTE *commandLine, DEBUGGER_PARSER *parser)
+{
+    if (commandLine) {}
+    if (parser) {}
+
+    return TRUE;
+}
+
+// SF
+
+ULONG ChangeSFFlag(BYTE *cmd,
+		  StackFrame *stackFrame, ULONG Exception,
+		  DEBUGGER_PARSER *parser)
+{
+     ULONG valid;
+     register ULONG value, oldD;
+
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     cmd = &cmd[parser->debugCommandNameLength];
+     while (*cmd && *cmd == ' ') cmd++;
+
+     value = EvaluateExpression(stackFrame, &cmd, &valid);
+     if (valid)
+     {
+	oldD = stackFrame->tSystemFlags & SF_FLAG;
+	(value) ? (stackFrame->tSystemFlags |= SF_FLAG) :
(stackFrame->tSystemFlags &= ~SF_FLAG);
+	DBGPrint("EFlag SF[%08X] changed to (%d)\n",
+				(unsigned)oldD, (int)value);
+     }
+     else
+	DBGPrint("invalid change flags command\n");
+     return TRUE;
+
+}
+
+ULONG displayPFHelp(BYTE *commandLine, DEBUGGER_PARSER *parser)
+{
+    if (commandLine) {}
+    if (parser) {}
+
+    return TRUE;
+}
+
+// PF
+
+ULONG ChangePFFlag(BYTE *cmd,
+		  StackFrame *stackFrame, ULONG Exception,
+		  DEBUGGER_PARSER *parser)
+{
+     ULONG valid;
+     register ULONG value, oldD;
+
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     cmd = &cmd[parser->debugCommandNameLength];
+     while (*cmd && *cmd == ' ') cmd++;
+
+     value = EvaluateExpression(stackFrame, &cmd, &valid);
+     if (valid)
+     {
+	oldD = stackFrame->tSystemFlags & PF_FLAG;
+	(value) ? (stackFrame->tSystemFlags |= PF_FLAG) :
(stackFrame->tSystemFlags &= ~PF_FLAG);
+	DBGPrint("EFlag PF[%08X] changed to (%d)\n",
+				(unsigned)oldD, (int)value);
+     }
+     else
+	DBGPrint("invalid change flags command\n");
+     return TRUE;
+
+}
+
+ULONG displayCFHelp(BYTE *commandLine, DEBUGGER_PARSER *parser)
+{
+    if (commandLine) {}
+    if (parser) {}
+
+    return TRUE;
+}
+
+// CF
+
+ULONG ChangeCFFlag(BYTE *cmd,
+		  StackFrame *stackFrame, ULONG Exception,
+		  DEBUGGER_PARSER *parser)
+{
+     ULONG valid;
+     register ULONG value, oldD;
+
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     cmd = &cmd[parser->debugCommandNameLength];
+     while (*cmd && *cmd == ' ') cmd++;
+
+     value = EvaluateExpression(stackFrame, &cmd, &valid);
+     if (valid)
+     {
+	oldD = stackFrame->tSystemFlags & CF_FLAG;
+	(value) ? (stackFrame->tSystemFlags |= CF_FLAG) :
(stackFrame->tSystemFlags &= ~CF_FLAG);
+	DBGPrint("EFlag CF[%08X] changed to (%d)\n",
+				(unsigned)oldD, (int)value);
+     }
+     else
+	DBGPrint("invalid change flags command\n");
+     return TRUE;
+
+}
+
+ULONG displayOFHelp(BYTE *commandLine, DEBUGGER_PARSER *parser)
+{
+    if (commandLine) {}
+    if (parser) {}
+
+    return TRUE;
+}
+
+// OF
+
+ULONG ChangeOFFlag(BYTE *cmd,
+		  StackFrame *stackFrame, ULONG Exception,
+		  DEBUGGER_PARSER *parser)
+{
+     ULONG valid;
+     register ULONG value, oldD;
+
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     cmd = &cmd[parser->debugCommandNameLength];
+     while (*cmd && *cmd == ' ') cmd++;
+
+     value = EvaluateExpression(stackFrame, &cmd, &valid);
+     if (valid)
+     {
+	oldD = stackFrame->tSystemFlags & OF_FLAG;
+	(value) ? (stackFrame->tSystemFlags |= OF_FLAG) :
(stackFrame->tSystemFlags &= ~OF_FLAG);
+	DBGPrint("EFlag OF[%08X] changed to (%d)\n",
+				(unsigned)oldD, (int)value);
+     }
+     else
+	DBGPrint("invalid change flags command\n");
+     return TRUE;
+
+}
+
+
+ULONG displayIFHelp(BYTE *commandLine, DEBUGGER_PARSER *parser)
+{
+    if (commandLine) {}
+    if (parser) {}
+
+    return TRUE;
+}
+
+// IF
+
+ULONG ChangeIFFlag(BYTE *cmd,
+		  StackFrame *stackFrame, ULONG Exception,
+		  DEBUGGER_PARSER *parser)
+{
+     ULONG valid;
+     register ULONG value, oldD;
+
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     cmd = &cmd[parser->debugCommandNameLength];
+     while (*cmd && *cmd == ' ') cmd++;
+
+     value = EvaluateExpression(stackFrame, &cmd, &valid);
+     if (valid)
+     {
+	oldD = stackFrame->tSystemFlags & IF_FLAG;
+	(value) ? (stackFrame->tSystemFlags |= IF_FLAG) :
(stackFrame->tSystemFlags &= ~IF_FLAG);
+	DBGPrint("EFlag IF[%08X] changed to (%d)\n",
+				(unsigned)oldD, (int)value);
+     }
+     else
+	DBGPrint("invalid change flags command\n");
+     return TRUE;
+
+}
+
+ULONG displayIDHelp(BYTE *commandLine, DEBUGGER_PARSER *parser)
+{
+    if (commandLine) {}
+    if (parser) {}
+
+    return TRUE;
+}
+
+// ID
+
+ULONG ChangeIDFlag(BYTE *cmd,
+		  StackFrame *stackFrame, ULONG Exception,
+		  DEBUGGER_PARSER *parser)
+{
+     ULONG valid;
+     register ULONG value, oldD;
+
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     cmd = &cmd[parser->debugCommandNameLength];
+     while (*cmd && *cmd == ' ') cmd++;
+
+     value = EvaluateExpression(stackFrame, &cmd, &valid);
+     if (valid)
+     {
+	oldD = stackFrame->tSystemFlags & ID_FLAGS;
+	(value) ? (stackFrame->tSystemFlags |= ID_FLAGS) :
(stackFrame->tSystemFlags &= ~ID_FLAGS);
+	DBGPrint("EFlag ID[%08X] changed to (%d)\n",
+				(unsigned)oldD, (int)value);
+     }
+     else
+	DBGPrint("invalid change flags command\n");
+     return TRUE;
+
+}
+
+ULONG displayDFHelp(BYTE *commandLine, DEBUGGER_PARSER *parser)
+{
+    if (commandLine) {}
+    if (parser) {}
+
+    return TRUE;
+}
+
+// DF
+
+ULONG ChangeDFFlag(BYTE *cmd,
+		  StackFrame *stackFrame, ULONG Exception,
+		  DEBUGGER_PARSER *parser)
+{
+
+     ULONG valid;
+     register ULONG value, oldD;
+
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     cmd = &cmd[parser->debugCommandNameLength];
+     while (*cmd && *cmd == ' ') cmd++;
+
+     value = EvaluateExpression(stackFrame, &cmd, &valid);
+     if (valid)
+     {
+	oldD = stackFrame->tSystemFlags & DF_FLAG;
+	(value) ? (stackFrame->tSystemFlags |= DF_FLAG) :
(stackFrame->tSystemFlags &= ~DF_FLAG);
+	DBGPrint("EFlag DF[%08X] changed to (%d)\n",
+				(unsigned)oldD, (int)value);
+     }
+     else
+	DBGPrint("invalid change flags command\n");
+     return TRUE;
+
+}
+
+ULONG displayNTHelp(BYTE *commandLine, DEBUGGER_PARSER *parser)
+{
+    if (commandLine) {}
+    if (parser) {}
+
+    return TRUE;
+}
+
+// NT
+
+ULONG ChangeNTFlag(BYTE *cmd,
+		  StackFrame *stackFrame, ULONG Exception,
+		  DEBUGGER_PARSER *parser)
+{
+     ULONG valid;
+     register ULONG value, oldD;
+
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     cmd = &cmd[parser->debugCommandNameLength];
+     while (*cmd && *cmd == ' ') cmd++;
+
+     value = EvaluateExpression(stackFrame, &cmd, &valid);
+     if (valid)
+     {
+	oldD = stackFrame->tSystemFlags & NT_FLAG;
+	(value) ? (stackFrame->tSystemFlags |= NT_FLAG) :
(stackFrame->tSystemFlags &= ~NT_FLAG);
+	DBGPrint("EFlag NT[%08X] changed to (%d)\n",
+				(unsigned)oldD, (int)value);
+     }
+     else
+	DBGPrint("invalid change flags command\n");
+     return TRUE;
+
+}
+
+ULONG displayVMHelp(BYTE *commandLine, DEBUGGER_PARSER *parser)
+{
+    if (commandLine) {}
+    if (parser) {}
+
+    return TRUE;
+}
+
+// VM
+
+ULONG ChangeVMFlag(BYTE *cmd,
+	       StackFrame *stackFrame, ULONG Exception,
+	       DEBUGGER_PARSER *parser)
+{
+     ULONG valid;
+     register ULONG value, oldD;
+
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     cmd = &cmd[parser->debugCommandNameLength];
+     while (*cmd && *cmd == ' ') cmd++;
+
+     value = EvaluateExpression(stackFrame, &cmd, &valid);
+     if (valid)
+     {
+	oldD = stackFrame->tSystemFlags & VM_FLAG;
+	(value) ? (stackFrame->tSystemFlags |= VM_FLAG) :
(stackFrame->tSystemFlags &= ~VM_FLAG);
+	DBGPrint("EFlag VM[%08X] changed to (%d)\n",
+				(unsigned)oldD, (int)value);
+     }
+     else
+	DBGPrint("invalid change flags command\n");
+     return TRUE;
+
+}
+
+
+ULONG displayVIFHelp(BYTE *commandLine, DEBUGGER_PARSER *parser)
+{
+    if (commandLine) {}
+    if (parser) {}
+
+    return TRUE;
+}
+
+// VIF
+
+ULONG ChangeVIFFlag(BYTE *cmd,
+		   StackFrame *stackFrame, ULONG Exception,
+		   DEBUGGER_PARSER *parser)
+{
+     ULONG valid;
+     register ULONG value, oldD;
+
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     cmd = &cmd[parser->debugCommandNameLength];
+     while (*cmd && *cmd == ' ') cmd++;
+
+     value = EvaluateExpression(stackFrame, &cmd, &valid);
+     if (valid)
+     {
+	oldD = stackFrame->tSystemFlags & VIF_FLAG;
+	(value) ? (stackFrame->tSystemFlags |= VIF_FLAG) :
(stackFrame->tSystemFlags &= ~VIF_FLAG);
+	DBGPrint("EFlag VIF[%08X] changed to (%d)\n",
+				(unsigned)oldD, (int)value);
+     }
+     else
+	DBGPrint("invalid change flags command\n");
+     return TRUE;
+
+}
+
+ULONG displayVIPHelp(BYTE *commandLine, DEBUGGER_PARSER *parser)
+{
+    if (commandLine) {}
+    if (parser) {}
+
+    return TRUE;
+}
+
+// VIP
+
+ULONG ChangeVIPFlag(BYTE *cmd,
+		   StackFrame *stackFrame, ULONG Exception,
+		   DEBUGGER_PARSER *parser)
+{
+     ULONG valid;
+     register ULONG value, oldD;
+
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     cmd = &cmd[parser->debugCommandNameLength];
+     while (*cmd && *cmd == ' ') cmd++;
+
+     value = EvaluateExpression(stackFrame, &cmd, &valid);
+     if (valid)
+     {
+	oldD = stackFrame->tSystemFlags & VIP_FLAG;
+	(value) ? (stackFrame->tSystemFlags |= VIP_FLAG) :
(stackFrame->tSystemFlags &= ~VIP_FLAG);
+	DBGPrint("EFlag VIP[%08X] changed to (%d)\n",
+				(unsigned)oldD, (int)value);
+     }
+     else
+	DBGPrint("invalid change flags command\n");
+     return TRUE;
+
+}
+
+ULONG displayAFHelp(BYTE *commandLine, DEBUGGER_PARSER *parser)
+{
+    if (commandLine) {}
+    if (parser) {}
+
+    return TRUE;
+}
+
+// AF
+
+ULONG ChangeAFFlag(BYTE *cmd,
+		  StackFrame *stackFrame, ULONG Exception,
+		  DEBUGGER_PARSER *parser)
+{
+     ULONG valid;
+     register ULONG value, oldD;
+
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     cmd = &cmd[parser->debugCommandNameLength];
+     while (*cmd && *cmd == ' ') cmd++;
+
+     value = EvaluateExpression(stackFrame, &cmd, &valid);
+     if (valid)
+     {
+	oldD = stackFrame->tSystemFlags & AF_FLAG;
+	(value) ? (stackFrame->tSystemFlags |= AF_FLAG) :
(stackFrame->tSystemFlags &= ~AF_FLAG);
+	DBGPrint("EFlag AF[%08X] changed to (%d)\n",
+				(unsigned)oldD, (int)value);
+     }
+     else
+	DBGPrint("invalid change flags command\n");
+     return TRUE;
+
+}
+
+
+ULONG displayACHelp(BYTE *commandLine, DEBUGGER_PARSER *parser)
+{
+    if (commandLine) {}
+    if (parser) {}
+
+    return TRUE;
+}
+
+// AC
+
+ULONG ChangeACFlag(BYTE *cmd,
+		  StackFrame *stackFrame, ULONG Exception,
+		  DEBUGGER_PARSER *parser)
+{
+     ULONG valid;
+     register ULONG value, oldD;
+
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     cmd = &cmd[parser->debugCommandNameLength];
+     while (*cmd && *cmd == ' ') cmd++;
+
+     value = EvaluateExpression(stackFrame, &cmd, &valid);
+     if (valid)
+     {
+	oldD = stackFrame->tSystemFlags & AC_FLAG;
+	(value) ? (stackFrame->tSystemFlags |= AC_FLAG) :
(stackFrame->tSystemFlags &= ~AC_FLAG);
+	DBGPrint("EFlag AC[%08X] changed to (%d)\n",
+				(unsigned)oldD, (int)value);
+     }
+     else
+	DBGPrint("invalid change flags command\n");
+     return TRUE;
+
+}
+
+ULONG displayMTRRHelp(BYTE *commandLine, DEBUGGER_PARSER *parser)
+{
+    if (commandLine) {}
+    if (parser) {}
+
+    DBGPrint("mtrr                     - display memory type range
registers\n");
+    return TRUE;
+}
+
+// MTRR
+
+ULONG DisplayMTRRRegisters(BYTE *cmd,
+			  StackFrame *stackFrame, ULONG Exception,
+			  DEBUGGER_PARSER *parser)
+{
+
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     displayMTRRRegisters();
+     return TRUE;
+
+}
+
+ULONG displayGDTHelp(BYTE *commandLine, DEBUGGER_PARSER *parser)
+{
+    if (commandLine) {}
+    if (parser) {}
+
+    DBGPrint(".g or .g <address>       - display global descriptor
table\n");
+    return TRUE;
+}
+
+// .G
+
+ULONG displayGDT(BYTE *cmd,
+		StackFrame *stackFrame, ULONG Exception,
+		DEBUGGER_PARSER *parser)
+{
+     register ULONG address;
+     ULONG valid;
+
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
+	DisplayGDT((BYTE *) address);
+     else
+	DisplayGDT((BYTE *) 0);
+     return TRUE;
+}
+
+ULONG displayIDTHelp(BYTE *commandLine, DEBUGGER_PARSER *parser)
+{
+    if (commandLine) {}
+    if (parser) {}
+
+    DBGPrint(".i or .i <address>       - display interrupt descriptor
table\n");
+    return TRUE;
+}
+
+// .I
+
+ULONG displayIDT(BYTE *cmd,
+		   StackFrame *stackFrame, ULONG Exception,
+		   DEBUGGER_PARSER *parser)
+{
+     register ULONG address;
+     ULONG valid;
+
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
+	DisplayIDT((BYTE *) address);
+     else
+	DisplayIDT((BYTE *) 0);
+     return TRUE;
+}
+
+ULONG evaluateExpressionHelp(BYTE *commandLine, DEBUGGER_PARSER *parser)
+{
+    extern void displayExpressionHelp(void);
+
+    if (commandLine) {}
+    if (parser) {}
+
+    displayExpressionHelp();
+    return TRUE;
+}
+
+// .E
+
+ULONG evaluateExpression(BYTE *cmd,
+		   StackFrame *stackFrame, ULONG Exception,
+		   DEBUGGER_PARSER *parser)
+{
+     extern void EvaluateCommandExpression(StackFrame *stackFrame,
+                                           BYTE *cmd);
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     cmd = &cmd[parser->debugCommandNameLength];
+     while (*cmd && *cmd == ' ') cmd++;
+
+     EvaluateCommandExpression(stackFrame, cmd);
+     return TRUE;
+}
+
+ULONG portCommandHelp(BYTE *commandLine, DEBUGGER_PARSER *parser)
+{
+    if (commandLine) {}
+    if (parser) {}
+
+    DBGPrint("i   <port>               - input byte from port\n");
+    DBGPrint("ib  <port>               - input byte from port\n");
+    DBGPrint("iw  <port>               - input word from port\n");
+    DBGPrint("il  <port>               - input double word from port\n");
+    DBGPrint("o   <port> <val>         - output byte to port\n");
+    DBGPrint("ob  <port> <val>         - output byte to port\n");
+    DBGPrint("ow  <port> <val>         - output word to port\n");
+    DBGPrint("ol  <port> <val>         - output double word to port\n");
+    return TRUE;
+}
+
+// IW
+
+ULONG inputWordPort(BYTE *cmd,
+		   StackFrame *stackFrame, ULONG Exception,
+		   DEBUGGER_PARSER *parser)
+{
+     register ULONG address;
+     ULONG valid;
+
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
+	DBGPrint("inportw (%04X) = %04X\n",
+                     (unsigned)address, (unsigned)inw(address));
+     }
+     else
+     {
+	DBGPrint("bad port command\n");
+     }
+     return TRUE;
+
+}
+
+// ID
+
+ULONG inputDoublePort(BYTE *cmd,
+		   StackFrame *stackFrame, ULONG Exception,
+		   DEBUGGER_PARSER *parser)
+{
+     register ULONG address;
+     ULONG valid;
+
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
+	DBGPrint("inportd (%04X) = %08X\n",
+			  (unsigned)address, (unsigned)inl(address));
+     }
+     else
+     {
+	DBGPrint("bad port command\n");
+     }
+     return TRUE;
+
+}
+
+// IB
+
+ULONG inputBytePort(BYTE *cmd,
+		   StackFrame *stackFrame, ULONG Exception,
+		   DEBUGGER_PARSER *parser)
+{
+     register ULONG address;
+     ULONG valid;
+
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
+	DBGPrint("inportb (%04X) = %02X\n",
+			  (unsigned)address, (unsigned)inb(address));
+     }
+     else
+     {
+	DBGPrint("bad port command\n");
+     }
+     return TRUE;
+
+}
+
+// I
+
+ULONG inputPort(BYTE *cmd,
+	       StackFrame *stackFrame, ULONG Exception,
+	       DEBUGGER_PARSER *parser)
+{
+     register ULONG address;
+     ULONG valid;
+
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
+	DBGPrint("inportb (%04X) = %02X\n",
+			  (unsigned)address, (unsigned)inb(address));
+     }
+     else
+     {
+	DBGPrint("bad port command\n");
+     }
+     return TRUE;
+
+}
+
+// OW
+
+ULONG outputWordPort(BYTE *cmd,
+		   StackFrame *stackFrame, ULONG Exception,
+		   DEBUGGER_PARSER *parser)
+{
+     register ULONG port, value;
+     ULONG valid;
+
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     cmd = &cmd[parser->debugCommandNameLength];
+     while (*cmd && *cmd == ' ') cmd++;
+
+     port = EvaluateExpression(stackFrame, &cmd, &valid);
+     if (valid)
+     {
+	value = EvaluateExpression(stackFrame, &cmd, &valid);
+	if (valid)
+	{
+	   DBGPrint("outportw (%04X) = %04X\n",
+				    (unsigned)port, (unsigned)value);
+	   outw(port, value);
+	   return TRUE;
+	}
+     }
+     else
+	DBGPrint("bad port command\n");
+
+     return TRUE;
+
+}
+
+// OD
+
+ULONG outputDoublePort(BYTE *cmd,
+		   StackFrame *stackFrame, ULONG Exception,
+		   DEBUGGER_PARSER *parser)
+{
+     register ULONG port, value;
+     ULONG valid;
+
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     cmd = &cmd[parser->debugCommandNameLength];
+     while (*cmd && *cmd == ' ') cmd++;
+
+     port = EvaluateExpression(stackFrame, &cmd, &valid);
+     if (valid)
+     {
+	value = EvaluateExpression(stackFrame, &cmd, &valid);
+	if (valid)
+	{
+	   DBGPrint("outportd (%04X) = %08X\n",
+			    (unsigned)port, (unsigned)value);
+	   outl(port, value);
+	   return TRUE;
+	}
+     }
+     else
+	DBGPrint("bad port command\n");
+
+     return TRUE;
+
+}
+
+// OB
+
+ULONG outputBytePort(BYTE *cmd,
+		   StackFrame *stackFrame, ULONG Exception,
+		   DEBUGGER_PARSER *parser)
+{
+     register ULONG port, value;
+     ULONG valid;
+
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     cmd = &cmd[parser->debugCommandNameLength];
+     while (*cmd && *cmd == ' ') cmd++;
+
+     port = EvaluateExpression(stackFrame, &cmd, &valid);
+     if (valid)
+     {
+	value = EvaluateExpression(stackFrame, &cmd, &valid);
+	if (valid)
+	{
+	   DBGPrint("outportb (%04X) = %02X\n",
+			    (unsigned)port, (unsigned)value);
+	   outb(port, value);
+	   return TRUE;
+	}
+     }
+     else
+	DBGPrint("bad port command\n");
+
+     return TRUE;
+
+}
+
+// O
+
+ULONG outputPort(BYTE *cmd,
+		StackFrame *stackFrame, ULONG Exception,
+		DEBUGGER_PARSER *parser)
+{
+     register ULONG port, value;
+     ULONG valid;
+
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     cmd = &cmd[parser->debugCommandNameLength];
+     while (*cmd && *cmd == ' ') cmd++;
+
+     port = EvaluateExpression(stackFrame, &cmd, &valid);
+     if (valid)
+     {
+	value = EvaluateExpression(stackFrame, &cmd, &valid);
+	if (valid)
+	{
+	   DBGPrint("outportb (%04X) = %02X\n",
+			    (unsigned)port, (unsigned)value);
+	   outb(port, value);
+	   return TRUE;
+	}
+     }
+     else
+	DBGPrint("bad port command\n");
+
+     return TRUE;
+
+}
+
+ULONG breakpointCommandHelp(BYTE *commandLine, DEBUGGER_PARSER *parser)
+{
+    if (commandLine) {}
+    if (parser) {}
+
+    DBGPrint("b                        - display all breakpoints\n");
+    DBGPrint("b   <address>            - set execute breakpoint\n");
+    DBGPrint("bc  [#] (1-4)            - clear breakpoint\n");
+    DBGPrint("bca                      - clear all breakpoints\n");
+    DBGPrint("br[#] <address>          - set read/write breakpoint #=1,2
or 4 byte len\n");
+    DBGPrint("bw[#] <address>          - set write only breakpoint #=1,2
or 4 byte len\n");
+    DBGPrint("bi[#] <address>          - set io address breakpoint #=1,2
or 4 byte len\n");
+    DBGPrint("bm  [p#]                 - mask breaks for specific
processor \n");
+    DBGPrint("bst                      - display temporary (go/proceed)
breakpoints\n");
+    return TRUE;
+}
+
+// BCA
+
+ULONG breakpointClearAll(BYTE *cmd,
+		       StackFrame *stackFrame, ULONG Exception,
+		   DEBUGGER_PARSER *parser)
+{
+     register ULONG i;
+
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     for (i=0; i < 4; i++)
+     {
+	BreakReserved[i] = 0;
+	BreakPoints[i] = 0;
+	BreakType[i] = 0;
+	BreakLength[i] = 0;
+	ConditionalBreakpoint[i] = 0;
+     }
+     SetDebugRegisters();
+     DBGPrint("all breakpoints cleared\n");
+
+     return TRUE;
+
+}
+
+// BC
+
+ULONG breakpointClear(BYTE *cmd,
+		   StackFrame *stackFrame, ULONG Exception,
+		   DEBUGGER_PARSER *parser)
+{
+     ULONG valid;
+     register ULONG i, address;
+     register BYTE *symbolName;
+     register BYTE *moduleName;
+     register int c = get_processor_id();
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
+	i = address;
+	if (i < 4)
+	{
+	   symbolName = GetSymbolFromValue(BreakPoints[i], &symbuf[c][0],
+                                           MAX_SYMBOL_LEN);
+	   moduleName = GetModuleInfoFromSymbolValue(BreakPoints[i],
+                                           &modbuf[c][0], MAX_SYMBOL_LEN);
+           if (moduleName)
+	      DBGPrint("breakpoint %i at 0x%08X (%s %s) %s|%s cleared\n",
+			     (int)i,
+			     (unsigned)BreakPoints[i],
+			     BreakDescription[(BreakType[i] & 3)],
+			     BreakLengthDescription[(BreakLength[i] & 3)],
+			     ((char *)(moduleName) ? (char *)(moduleName)
+                             : (char *)("")),
+			     ((char *)(symbolName) ? (char *)(symbolName)
+                             : (char *)("")));
+           else
+	      DBGPrint("breakpoint %i at 0x%08X (%s %s) %s cleared\n",
+			     (int)i,
+			     (unsigned)BreakPoints[i],
+			     BreakDescription[(BreakType[i] & 3)],
+			     BreakLengthDescription[(BreakLength[i] & 3)],
+			     ((char *)(symbolName) ? (char *)(symbolName)
+                             : (char *)("")));
+	   BreakReserved[i] = 0;
+	   BreakPoints[i] = 0;
+	   BreakType[i] = 0;
+	   BreakLength[i] = 0;
+	   ConditionalBreakpoint[i] = 0;
+	   SetDebugRegisters();
+	   return TRUE;
+	}
+	else
+	   DBGPrint("breakpoint out of range\n");
+	return TRUE;
+     }
+     DBGPrint("breakpoint not found\n");
+     return TRUE;
+}
+
+// BM
+
+ULONG breakpointMask(BYTE *cmd,
+		   StackFrame *stackFrame, ULONG Exception,
+		   DEBUGGER_PARSER *parser)
+{
+     register ULONG address, pnum, i;
+     ULONG valid;
+
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
+	pnum = address;
+	if (pnum < MAX_PROCESSORS)
+	{
+	   if (BreakMask[pnum])
+	      BreakMask[pnum] = 0;
+	   else
+	      BreakMask[pnum] = 1;
+	   DBGPrint("processor %i : %s\n", (int)pnum,
+		   BreakMask[pnum] ? "BREAKS_MASKED" : "BREAKS_UNMASKED");
+	}
+	else
+	   DBGPrint("processor (%i) invalid\n", (int)pnum);
+     }
+     else
+     {
+	for (i=0; i < MAX_PROCESSORS; i++)
+	{
+	   DBGPrint("processor %i : %s\n", (int)i,
+		    BreakMask[i] ? "BREAKS_MASKED" : "BREAKS_UNMASKED");
+	}
+     }
+     return TRUE;
+
+}
+
+// BW1
+
+ULONG breakpointWord1(BYTE *cmd,
+		    StackFrame *stackFrame, ULONG Exception,
+		    DEBUGGER_PARSER *parser)
+{
+     register ULONG address, i, r;
+     register BYTE *pB, *symbolName;
+     register BYTE *moduleName;
+     ULONG valid;
+     register int c = get_processor_id();
+
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
+	for (i=0; i < 4; i++)
+	{
+	   if (!BreakReserved[i])
+	   {
+	      pB = cmd;
+	      EvaluateExpression(stackFrame, &cmd, &valid);
+	      if (valid)
+	      {
+		 ConditionalBreakpoint[i] = 1;
+		 for (r=0; (r < 255) && (*pB); r++)
+		    BreakCondition[i][r] = *pB++;
+		 BreakCondition[i][r] = '\0';
+	      }
+	      BreakReserved[i] = 1;
+	      BreakPoints[i] = address;
+	      BreakType[i] = BREAK_WRITE;
+	      BreakLength[i] = ONE_BYTE_FIELD;
+	      symbolName = GetSymbolFromValue(address, &symbuf[c][0],
+                                           MAX_SYMBOL_LEN);
+	      moduleName = GetModuleInfoFromSymbolValue(address, &modbuf[c][0],
+                                           MAX_SYMBOL_LEN);
+              if (moduleName)
+	         DBGPrint("breakpoint %i set to 0x%08X (%s %s) %s|%s\n",
+				 (int)i,
+				 (unsigned)BreakPoints[i],
+				 BreakDescription[(BreakType[i] & 3)],
+				 BreakLengthDescription[(BreakLength[i] & 3)],
+		               ((char *)(moduleName) ? (char *)(moduleName)
+                                 : (char *)("")),
+			         ((char *)(symbolName) ? (char *)(symbolName)
+                                 : (char *)("")));
+              else
+	         DBGPrint("breakpoint %i set to 0x%08X (%s %s) %s\n",
+				 (int)i,
+				 (unsigned)BreakPoints[i],
+				 BreakDescription[(BreakType[i] & 3)],
+				 BreakLengthDescription[(BreakLength[i] & 3)],
+			         ((char *)(symbolName) ? (char *)(symbolName)
+                                 : (char *)("")));
+
+	      if (ConditionalBreakpoint[i])
+		 DBGPrint("if (%s) is TRUE\n", BreakCondition[i]);
+
+	      SetDebugRegisters();
+	      return TRUE;
+	   }
+	}
+	DBGPrint("no breakpoint available\n");
+     }
+     else
+	DBGPrint("breakpoint parameters invalid\n");
+     return TRUE;
+
+}
+
+// BW2
+
+ULONG breakpointWord2(BYTE *cmd,
+		    StackFrame *stackFrame, ULONG Exception,
+		    DEBUGGER_PARSER *parser)
+{
+     register ULONG address, i, r;
+     register BYTE *pB, *symbolName;
+     register BYTE *moduleName;
+     ULONG valid;
+     register int c = get_processor_id();
+
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
+	for (i=0; i < 4; i++)
+	{
+	   if (!BreakReserved[i])
+	   {
+	      pB = cmd;
+	      EvaluateExpression(stackFrame, &cmd, &valid);
+	      if (valid)
+	      {
+		 ConditionalBreakpoint[i] = 1;
+		 for (r=0; (r < 255) && (*pB); r++)
+		    BreakCondition[i][r] = *pB++;
+		 BreakCondition[i][r] = '\0';
+	      }
+	      BreakReserved[i] = 1;
+	      BreakPoints[i] = address;
+	      BreakType[i] = BREAK_WRITE;
+	      BreakLength[i] = TWO_BYTE_FIELD;
+	      symbolName = GetSymbolFromValue(address, &symbuf[c][0],
+                                           MAX_SYMBOL_LEN);
+	      moduleName = GetModuleInfoFromSymbolValue(address, &modbuf[c][0],
+                                           MAX_SYMBOL_LEN);
+              if (moduleName)
+	         DBGPrint("breakpoint %i set to 0x%08X (%s %s) %s|%s\n",
+				 (int)i,
+				 (unsigned)BreakPoints[i],
+				 BreakDescription[(BreakType[i] & 3)],
+				 BreakLengthDescription[(BreakLength[i] & 3)],
+			        ((char *)(moduleName) ? (char *)(moduleName)
+                                 : (char *)("")),
+			         ((char *)(symbolName) ? (char *)(symbolName)
+                                 : (char *)("")));
+              else
+	         DBGPrint("breakpoint %i set to 0x%08X (%s %s) %s\n",
+				 (int)i,
+				 (unsigned)BreakPoints[i],
+				 BreakDescription[(BreakType[i] & 3)],
+				 BreakLengthDescription[(BreakLength[i] & 3)],
+			         ((char *)(symbolName) ? (char *)(symbolName)
+                                 : (char *)("")));
+
+	      if (ConditionalBreakpoint[i])
+		 DBGPrint("if (%s) is TRUE\n", BreakCondition[i]);
+
+	      SetDebugRegisters();
+	      return TRUE;
+	   }
+	}
+	DBGPrint("no breakpoint available\n");
+     }
+     else
+	DBGPrint("breakpoint parameters invalid\n");
+     return TRUE;
+
+}
+
+// BW4
+
+ULONG breakpointWord4(BYTE *cmd,
+		    StackFrame *stackFrame, ULONG Exception,
+		    DEBUGGER_PARSER *parser)
+{
+     register ULONG address, i, r;
+     register BYTE *pB, *symbolName;
+     register BYTE *moduleName;
+     ULONG valid;
+     register int c = get_processor_id();
+
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
+	for (i=0; i < 4; i++)
+	{
+	   if (!BreakReserved[i])
+	   {
+	      pB = cmd;
+	      EvaluateExpression(stackFrame, &cmd, &valid);
+	      if (valid)
+	      {
+		 ConditionalBreakpoint[i] = 1;
+		 for (r=0; (r < 255) && (*pB); r++)
+		    BreakCondition[i][r] = *pB++;
+		 BreakCondition[i][r] = '\0';
+	      }
+	      BreakReserved[i] = 1;
+	      BreakPoints[i] = address;
+	      BreakType[i] = BREAK_WRITE;
+	      BreakLength[i] = FOUR_BYTE_FIELD;
+	      symbolName = GetSymbolFromValue(address, &symbuf[c][0],
+                                           MAX_SYMBOL_LEN);
+	      moduleName = GetModuleInfoFromSymbolValue(address, &modbuf[c][0],
+                                           MAX_SYMBOL_LEN);
+              if (moduleName)
+	         DBGPrint("breakpoint %i set to 0x%08X (%s %s) %s|%s\n",
+				 (int)i,
+				 (unsigned)BreakPoints[i],
+				 BreakDescription[(BreakType[i] & 3)],
+				 BreakLengthDescription[(BreakLength[i] & 3)],
+			        ((char *)(moduleName) ? (char *)(moduleName)
+                                 : (char *)("")),
+			         ((char *)(symbolName) ? (char *)(symbolName)
+                                 : (char *)("")));
+              else
+	         DBGPrint("breakpoint %i set to 0x%08X (%s %s) %s\n",
+				 (int)i,
+				 (unsigned)BreakPoints[i],
+				 BreakDescription[(BreakType[i] & 3)],
+				 BreakLengthDescription[(BreakLength[i] & 3)],
+			         ((char *)(symbolName) ? (char *)(symbolName)
+                                 : (char *)("")));
+
+	      if (ConditionalBreakpoint[i])
+		 DBGPrint("if (%s) is TRUE\n", BreakCondition[i]);
+
+	      SetDebugRegisters();
+	      return TRUE;
+	   }
+	}
+	DBGPrint("no breakpoint available\n");
+     }
+     else
+	DBGPrint("breakpoint parameters invalid\n");
+     return TRUE;
+
+}
+
+// BW
+
+ULONG breakpointWord(BYTE *cmd,
+		    StackFrame *stackFrame, ULONG Exception,
+		    DEBUGGER_PARSER *parser)
+{
+     register ULONG address, i, r;
+     register BYTE *pB, *symbolName;
+     register BYTE *moduleName;
+     ULONG valid;
+     register int c = get_processor_id();
+
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
+	for (i=0; i < 4; i++)
+	{
+	   if (!BreakReserved[i])
+	   {
+	      pB = cmd;
+	      EvaluateExpression(stackFrame, &cmd, &valid);
+	      if (valid)
+	      {
+		 ConditionalBreakpoint[i] = 1;
+		 for (r=0; (r < 255) && (*pB); r++)
+		    BreakCondition[i][r] = *pB++;
+		 BreakCondition[i][r] = '\0';
+	      }
+	      BreakReserved[i] = 1;
+	      BreakPoints[i] = address;
+	      BreakType[i] = BREAK_WRITE;
+	      BreakLength[i] = ONE_BYTE_FIELD;
+	      symbolName = GetSymbolFromValue(address, &symbuf[c][0],
+                                           MAX_SYMBOL_LEN);
+	      moduleName = GetModuleInfoFromSymbolValue(address, &modbuf[c][0],
+                                           MAX_SYMBOL_LEN);
+              if (moduleName)
+	         DBGPrint("breakpoint %i set to 0x%08X (%s %s) %s|%s\n",
+				 (int)i,
+				 (unsigned)BreakPoints[i],
+				 BreakDescription[(BreakType[i] & 3)],
+				 BreakLengthDescription[(BreakLength[i] & 3)],
+			        ((char *)(moduleName) ? (char *)(moduleName)
+                                 : (char *)("")),
+			         ((char *)(symbolName) ? (char *)(symbolName)
+                                 : (char *)("")));
+              else
+	         DBGPrint("breakpoint %i set to 0x%08X (%s %s) %s\n",
+				 (int)i,
+				 (unsigned)BreakPoints[i],
+				 BreakDescription[(BreakType[i] & 3)],
+				 BreakLengthDescription[(BreakLength[i] & 3)],
+			         ((char *)(symbolName) ? (char *)(symbolName)
+                                 : (char *)("")));
+
+	      if (ConditionalBreakpoint[i])
+		 DBGPrint("if (%s) is TRUE\n", BreakCondition[i]);
+
+	      SetDebugRegisters();
+	      return TRUE;
+	   }
+	}
+	DBGPrint("no breakpoint available\n");
+     }
+     else
+	DBGPrint("breakpoint parameters invalid\n");
+     return TRUE;
+
+}
+
+
+// BR1
+
+ULONG breakpointRead1(BYTE *cmd,
+		   StackFrame *stackFrame, ULONG Exception,
+		   DEBUGGER_PARSER *parser)
+{
+     register ULONG address, i, r;
+     register BYTE *pB, *symbolName;
+     register BYTE *moduleName;
+     ULONG valid;
+     register int c = get_processor_id();
+
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
+	for (i=0; i < 4; i++)
+	{
+	   if (!BreakReserved[i])
+	   {
+	      pB = cmd;
+	      EvaluateExpression(stackFrame, &cmd, &valid);
+	      if (valid)
+	      {
+		 ConditionalBreakpoint[i] = 1;
+		 for (r=0; (r < 255) && (*pB); r++)
+		    BreakCondition[i][r] = *pB++;
+		 BreakCondition[i][r] = '\0';
+	      }
+	      BreakReserved[i] = 1;
+	      BreakPoints[i] = address;
+	      BreakType[i] = BREAK_READWRITE;
+	      BreakLength[i] = ONE_BYTE_FIELD;
+	      symbolName = GetSymbolFromValue(address, &symbuf[c][0],
+                                           MAX_SYMBOL_LEN);
+	      moduleName = GetModuleInfoFromSymbolValue(address, &modbuf[c][0],
+                                           MAX_SYMBOL_LEN);
+              if (moduleName)
+	         DBGPrint("breakpoint %i set to 0x%08X (%s %s) %s|%s\n",
+				 (int)i,
+				 (unsigned)BreakPoints[i],
+				 BreakDescription[(BreakType[i] & 3)],
+				 BreakLengthDescription[(BreakLength[i] & 3)],
+			        ((char *)(moduleName) ? (char *)(moduleName)
+                                 : (char *)("")),
+			         ((char *)(symbolName) ? (char *)(symbolName)
+                                 : (char *)("")));
+              else
+	         DBGPrint("breakpoint %i set to 0x%08X (%s %s) %s\n",
+				 (int)i,
+				 (unsigned)BreakPoints[i],
+				 BreakDescription[(BreakType[i] & 3)],
+				 BreakLengthDescription[(BreakLength[i] & 3)],
+			         ((char *)(symbolName) ? (char *)(symbolName)
+                                 : (char *)("")));
+
+	      if (ConditionalBreakpoint[i])
+		 DBGPrint("if (%s) is TRUE\n", BreakCondition[i]);
+
+	      SetDebugRegisters();
+	      return TRUE;
+	   }
+	}
+	DBGPrint("no breakpoint available\n");
+     }
+     else
+	DBGPrint("breakpoint parameters invalid\n");
+     return TRUE;
+
+}
+
+
+// BR2
+
+ULONG breakpointRead2(BYTE *cmd,
+		   StackFrame *stackFrame, ULONG Exception,
+		   DEBUGGER_PARSER *parser)
+{
+     register ULONG address, i, r;
+     register BYTE *pB, *symbolName;
+     register BYTE *moduleName;
+     ULONG valid;
+     register int c = get_processor_id();
+
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
+	for (i=0; i < 4; i++)
+	{
+	   if (!BreakReserved[i])
+	   {
+	      pB = cmd;
+	      EvaluateExpression(stackFrame, &cmd, &valid);
+	      if (valid)
+	      {
+		 ConditionalBreakpoint[i] = 1;
+		 for (r=0; (r < 255) && (*pB); r++)
+		    BreakCondition[i][r] = *pB++;
+		 BreakCondition[i][r] = '\0';
+	      }
+	      BreakReserved[i] = 1;
+	      BreakPoints[i] = address;
+	      BreakType[i] = BREAK_READWRITE;
+	      BreakLength[i] = TWO_BYTE_FIELD;
+	      symbolName = GetSymbolFromValue(address, &symbuf[c][0],
+                                           MAX_SYMBOL_LEN);
+	      moduleName = GetModuleInfoFromSymbolValue(address, &modbuf[c][0],
+                                           MAX_SYMBOL_LEN);
+              if (moduleName)
+	         DBGPrint("breakpoint %i set to 0x%08X (%s %s) %s|%s\n",
+				 (int)i,
+				 (unsigned)BreakPoints[i],
+				 BreakDescription[(BreakType[i] & 3)],
+				 BreakLengthDescription[(BreakLength[i] & 3)],
+			        ((char *)(moduleName) ? (char *)(moduleName)
+                                 : (char *)("")),
+			         ((char *)(symbolName) ? (char *)(symbolName)
+                                 : (char *)("")));
+              else
+	         DBGPrint("breakpoint %i set to 0x%08X (%s %s) %s\n",
+				 (int)i,
+				 (unsigned)BreakPoints[i],
+				 BreakDescription[(BreakType[i] & 3)],
+				 BreakLengthDescription[(BreakLength[i] & 3)],
+			         ((char *)(symbolName) ? (char *)(symbolName)
+                                 : (char *)("")));
+
+	      if (ConditionalBreakpoint[i])
+		 DBGPrint("if (%s) is TRUE\n", BreakCondition[i]);
+
+	      SetDebugRegisters();
+	      return TRUE;
+	   }
+	}
+	DBGPrint("no breakpoint available\n");
+     }
+     else
+	DBGPrint("breakpoint parameters invalid\n");
+     return TRUE;
+
+}
+
+
+// BR4
+
+ULONG breakpointRead4(BYTE *cmd,
+		   StackFrame *stackFrame, ULONG Exception,
+		   DEBUGGER_PARSER *parser)
+{
+     register ULONG address, i, r;
+     register BYTE *pB, *symbolName;
+     register BYTE *moduleName;
+     ULONG valid;
+     register int c = get_processor_id();
+
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
+	for (i=0; i < 4; i++)
+	{
+	   if (!BreakReserved[i])
+	   {
+	      pB = cmd;
+	      EvaluateExpression(stackFrame, &cmd, &valid);
+	      if (valid)
+	      {
+		 ConditionalBreakpoint[i] = 1;
+		 for (r=0; (r < 255) && (*pB); r++)
+		    BreakCondition[i][r] = *pB++;
+		 BreakCondition[i][r] = '\0';
+	      }
+	      BreakReserved[i] = 1;
+	      BreakPoints[i] = address;
+	      BreakType[i] = BREAK_READWRITE;
+	      BreakLength[i] = FOUR_BYTE_FIELD;
+	      symbolName = GetSymbolFromValue(address, &symbuf[c][0],
+                                           MAX_SYMBOL_LEN);
+	      moduleName = GetModuleInfoFromSymbolValue(address, &modbuf[c][0],
+                                           MAX_SYMBOL_LEN);
+              if (moduleName)
+	         DBGPrint("breakpoint %i set to 0x%08X (%s %s) %s|%s\n",
+				 (int)i,
+				 (unsigned)BreakPoints[i],
+				 BreakDescription[(BreakType[i] & 3)],
+				 BreakLengthDescription[(BreakLength[i] & 3)],
+			        ((char *)(moduleName) ? (char *)(moduleName)
+                                 : (char *)("")),
+			         ((char *)(symbolName) ? (char *)(symbolName)
+                                 : (char *)("")));
+              else
+	         DBGPrint("breakpoint %i set to 0x%08X (%s %s) %s\n",
+				 (int)i,
+				 (unsigned)BreakPoints[i],
+				 BreakDescription[(BreakType[i] & 3)],
+				 BreakLengthDescription[(BreakLength[i] & 3)],
+			         ((char *)(symbolName) ? (char *)(symbolName)
+                                 : (char *)("")));
+
+	      if (ConditionalBreakpoint[i])
+		 DBGPrint("if (%s) is TRUE\n", BreakCondition[i]);
+
+	      SetDebugRegisters();
+	      return TRUE;
+	   }
+	}
+	DBGPrint("no breakpoint available\n");
+     }
+     else
+	DBGPrint("breakpoint parameters invalid\n");
+     return TRUE;
+
+}
+
+
+// BR
+
+ULONG breakpointRead(BYTE *cmd,
+		   StackFrame *stackFrame, ULONG Exception,
+		   DEBUGGER_PARSER *parser)
+{
+     register ULONG address, i, r;
+     register BYTE *pB, *symbolName;
+     register BYTE *moduleName;
+     ULONG valid;
+     register int c = get_processor_id();
+
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
+	for (i=0; i < 4; i++)
+	{
+	   if (!BreakReserved[i])
+	   {
+	      pB = cmd;
+	      EvaluateExpression(stackFrame, &cmd, &valid);
+	      if (valid)
+	      {
+		 ConditionalBreakpoint[i] = 1;
+		 for (r=0; (r < 255) && (*pB); r++)
+		    BreakCondition[i][r] = *pB++;
+		 BreakCondition[i][r] = '\0';
+	      }
+	      BreakReserved[i] = 1;
+	      BreakPoints[i] = address;
+	      BreakType[i] = BREAK_READWRITE;
+	      BreakLength[i] = ONE_BYTE_FIELD;
+	      symbolName = GetSymbolFromValue(address, &symbuf[c][0],
+                                           MAX_SYMBOL_LEN);
+	      moduleName = GetModuleInfoFromSymbolValue(address, &modbuf[c][0],
+                                           MAX_SYMBOL_LEN);
+              if (moduleName)
+	         DBGPrint("breakpoint %i set to 0x%08X (%s %s) %s|%s\n",
+				 (int)i,
+				 (unsigned)BreakPoints[i],
+				 BreakDescription[(BreakType[i] & 3)],
+				 BreakLengthDescription[(BreakLength[i] & 3)],
+			        ((char *)(moduleName) ? (char *)(moduleName)
+                                 : (char *)("")),
+			         ((char *)(symbolName) ? (char *)(symbolName)
+                                 : (char *)("")));
+              else
+	         DBGPrint("breakpoint %i set to 0x%08X (%s %s) %s\n",
+				 (int)i,
+				 (unsigned)BreakPoints[i],
+				 BreakDescription[(BreakType[i] & 3)],
+				 BreakLengthDescription[(BreakLength[i] & 3)],
+			         ((char *)(symbolName) ? (char *)(symbolName)
+                                 : (char *)("")));
+
+	      if (ConditionalBreakpoint[i])
+		 DBGPrint("if (%s) is TRUE\n", BreakCondition[i]);
+
+	      SetDebugRegisters();
+	      return TRUE;
+	   }
+	}
+	DBGPrint("no breakpoint available\n");
+     }
+     else
+	DBGPrint("breakpoint parameters invalid\n");
+     return TRUE;
+
+}
+
+// BI1
+
+ULONG breakpointIO1(BYTE *cmd,
+		   StackFrame *stackFrame, ULONG Exception,
+		   DEBUGGER_PARSER *parser)
+{
+     register ULONG address, i, r;
+     register BYTE *pB, *symbolName;
+     register BYTE *moduleName;
+     ULONG valid;
+     register int c = get_processor_id();
+
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
+	for (i=0; i < 4; i++)
+	{
+	   if (!BreakReserved[i])
+	   {
+	      pB = cmd;
+	      EvaluateExpression(stackFrame, &cmd, &valid);
+	      if (valid)
+	      {
+		 ConditionalBreakpoint[i] = 1;
+		 for (r=0; (r < 255) && (*pB); r++)
+		    BreakCondition[i][r] = *pB++;
+		 BreakCondition[i][r] = '\0';
+	      }
+	      BreakReserved[i] = 1;
+	      BreakPoints[i] = address;
+	      BreakType[i] = BREAK_IOPORT;
+	      BreakLength[i] = ONE_BYTE_FIELD;
+	      symbolName = GetSymbolFromValue(address, &symbuf[c][0],
+                                           MAX_SYMBOL_LEN);
+	      moduleName = GetModuleInfoFromSymbolValue(address, &modbuf[c][0],
+                                           MAX_SYMBOL_LEN);
+              if (moduleName)
+	         DBGPrint("breakpoint %i set to 0x%08X (%s %s) %s|%s\n",
+				 (int)i,
+				 (unsigned)BreakPoints[i],
+				 BreakDescription[(BreakType[i] & 3)],
+				 BreakLengthDescription[(BreakLength[i] & 3)],
+			        ((char *)(moduleName) ? (char *)(moduleName)
+                                 : (char *)("")),
+			         ((char *)(symbolName) ? (char *)(symbolName)
+                                 : (char *)("")));
+              else
+	         DBGPrint("breakpoint %i set to 0x%08X (%s %s) %s\n",
+				 (int)i,
+				 (unsigned)BreakPoints[i],
+				 BreakDescription[(BreakType[i] & 3)],
+				 BreakLengthDescription[(BreakLength[i] & 3)],
+			         ((char *)(symbolName) ? (char *)(symbolName)
+                                 : (char *)("")));
+
+	      if (ConditionalBreakpoint[i])
+		 DBGPrint("if (%s) is TRUE\n", BreakCondition[i]);
+
+	      SetDebugRegisters();
+	      return TRUE;
+	   }
+	}
+	DBGPrint("no breakpoint available\n");
+     }
+     else
+	DBGPrint("breakpoint parameters invalid\n");
+     return TRUE;
+
+}
+
+// BI2
+
+ULONG breakpointIO2(BYTE *cmd,
+		   StackFrame *stackFrame, ULONG Exception,
+		   DEBUGGER_PARSER *parser)
+{
+     register ULONG address, i, r;
+     register BYTE *pB, *symbolName;
+     register BYTE *moduleName;
+     ULONG valid;
+     register int c = get_processor_id();
+
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
+	for (i=0; i < 4; i++)
+	{
+	   if (!BreakReserved[i])
+	   {
+	      pB = cmd;
+	      EvaluateExpression(stackFrame, &cmd, &valid);
+	      if (valid)
+	      {
+		 ConditionalBreakpoint[i] = 1;
+		 for (r=0; (r < 255) && (*pB); r++)
+		    BreakCondition[i][r] = *pB++;
+		 BreakCondition[i][r] = '\0';
+	      }
+	      BreakReserved[i] = 1;
+	      BreakPoints[i] = address;
+	      BreakType[i] = BREAK_IOPORT;
+	      BreakLength[i] = TWO_BYTE_FIELD;
+	      symbolName = GetSymbolFromValue(address, &symbuf[c][0],
+                                           MAX_SYMBOL_LEN);
+	      moduleName = GetModuleInfoFromSymbolValue(address, &modbuf[c][0],
+                                           MAX_SYMBOL_LEN);
+              if (moduleName)
+	         DBGPrint("breakpoint %i set to 0x%08X (%s %s) %s|%s\n",
+				 (int)i,
+				 (unsigned)BreakPoints[i],
+				 BreakDescription[(BreakType[i] & 3)],
+				 BreakLengthDescription[(BreakLength[i] & 3)],
+			        ((char *)(moduleName) ? (char *)(moduleName)
+                                 : (char *)("")),
+			         ((char *)(symbolName) ? (char *)(symbolName)
+                                 : (char *)("")));
+              else
+	         DBGPrint("breakpoint %i set to 0x%08X (%s %s) %s\n",
+				 (int)i,
+				 (unsigned)BreakPoints[i],
+				 BreakDescription[(BreakType[i] & 3)],
+				 BreakLengthDescription[(BreakLength[i] & 3)],
+			         ((char *)(symbolName) ? (char *)(symbolName)
+                                 : (char *)("")));
+
+	      if (ConditionalBreakpoint[i])
+		 DBGPrint("if (%s) is TRUE\n", BreakCondition[i]);
+
+	      SetDebugRegisters();
+	      return TRUE;
+	   }
+	}
+	DBGPrint("no breakpoint available\n");
+     }
+     else
+	DBGPrint("breakpoint parameters invalid\n");
+     return TRUE;
+
+}
+
+// BI4
+
+ULONG breakpointIO4(BYTE *cmd,
+		   StackFrame *stackFrame, ULONG Exception,
+		   DEBUGGER_PARSER *parser)
+{
+     register ULONG address, i, r;
+     register BYTE *pB, *symbolName;
+     register BYTE *moduleName;
+     ULONG valid;
+     register int c = get_processor_id();
+
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
+	for (i=0; i < 4; i++)
+	{
+	   if (!BreakReserved[i])
+	   {
+	      pB = cmd;
+	      EvaluateExpression(stackFrame, &cmd, &valid);
+	      if (valid)
+	      {
+		 ConditionalBreakpoint[i] = 1;
+		 for (r=0; (r < 255) && (*pB); r++)
+		    BreakCondition[i][r] = *pB++;
+		 BreakCondition[i][r] = '\0';
+	      }
+	      BreakReserved[i] = 1;
+	      BreakPoints[i] = address;
+	      BreakType[i] = BREAK_IOPORT;
+	      BreakLength[i] = FOUR_BYTE_FIELD;
+	      symbolName = GetSymbolFromValue(address, &symbuf[c][0],
+                                           MAX_SYMBOL_LEN);
+	      moduleName = GetModuleInfoFromSymbolValue(address, &modbuf[c][0],
+                                           MAX_SYMBOL_LEN);
+              if (moduleName)
+	         DBGPrint("breakpoint %i set to 0x%08X (%s %s) %s|%s\n",
+				 (int)i,
+				 (unsigned)BreakPoints[i],
+				 BreakDescription[(BreakType[i] & 3)],
+				 BreakLengthDescription[(BreakLength[i] & 3)],
+			        ((char *)(moduleName) ? (char *)(moduleName)
+                                 : (char *)("")),
+			         ((char *)(symbolName) ? (char *)(symbolName)
+                                 : (char *)("")));
+              else
+	         DBGPrint("breakpoint %i set to 0x%08X (%s %s) %s\n",
+				 (int)i,
+				 (unsigned)BreakPoints[i],
+				 BreakDescription[(BreakType[i] & 3)],
+				 BreakLengthDescription[(BreakLength[i] & 3)],
+			         ((char *)(symbolName) ? (char *)(symbolName)
+                                 : (char *)("")));
+
+	      if (ConditionalBreakpoint[i])
+		 DBGPrint("if (%s) is TRUE\n", BreakCondition[i]);
+
+	      SetDebugRegisters();
+	      return TRUE;
+	   }
+	}
+	DBGPrint("no breakpoint available\n");
+     }
+     else
+	DBGPrint("breakpoint parameters invalid\n");
+     return TRUE;
+
+}
+
+// BI
+
+ULONG breakpointIO(BYTE *cmd,
+		   StackFrame *stackFrame, ULONG Exception,
+		   DEBUGGER_PARSER *parser)
+{
+     register ULONG address, i, r;
+     register BYTE *pB, *symbolName;
+     register BYTE *moduleName;
+     ULONG valid;
+     register int c = get_processor_id();
+
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
+	for (i=0; i < 4; i++)
+	{
+	   if (!BreakReserved[i])
+	   {
+	      pB = cmd;
+	      EvaluateExpression(stackFrame, &cmd, &valid);
+	      if (valid)
+	      {
+		 ConditionalBreakpoint[i] = 1;
+		 for (r=0; (r < 255) && (*pB); r++)
+		    BreakCondition[i][r] = *pB++;
+		 BreakCondition[i][r] = '\0';
+	      }
+	      BreakReserved[i] = 1;
+	      BreakPoints[i] = address;
+	      BreakType[i] = BREAK_IOPORT;
+	      BreakLength[i] = ONE_BYTE_FIELD;
+	      symbolName = GetSymbolFromValue(address, &symbuf[c][0],
+                                           MAX_SYMBOL_LEN);
+	      moduleName = GetModuleInfoFromSymbolValue(address, &modbuf[c][0],
+                                           MAX_SYMBOL_LEN);
+              if (moduleName)
+	         DBGPrint("breakpoint %i set to 0x%08X (%s %s) %s|%s\n",
+				 (int)i,
+				 (unsigned)BreakPoints[i],
+				 BreakDescription[(BreakType[i] & 3)],
+				 BreakLengthDescription[(BreakLength[i] & 3)],
+			        ((char *)(moduleName) ? (char *)(moduleName)
+                                 : (char *)("")),
+			         ((char *)(symbolName) ? (char *)(symbolName)
+                                 : (char *)("")));
+              else
+ 	         DBGPrint("breakpoint %i set to 0x%08X (%s %s) %s\n",
+				 (int)i,
+				 (unsigned)BreakPoints[i],
+				 BreakDescription[(BreakType[i] & 3)],
+				 BreakLengthDescription[(BreakLength[i] & 3)],
+			         ((char *)(symbolName) ? (char *)(symbolName)
+                                 : (char *)("")));
+
+	      if (ConditionalBreakpoint[i])
+		 DBGPrint("if (%s) is TRUE\n", BreakCondition[i]);
+
+	      SetDebugRegisters();
+	      return TRUE;
+	   }
+	}
+	DBGPrint("no breakpoint available\n");
+     }
+     else
+	DBGPrint("breakpoint parameters invalid\n");
+     return TRUE;
+
+}
+
+// B
+
+ULONG breakpointExecute(BYTE *cmd,
+		   StackFrame *stackFrame, ULONG Exception,
+		   DEBUGGER_PARSER *parser)
+{
+     register ULONG address, i, r;
+     register BYTE *pB, *symbolName;
+     register BYTE *moduleName;
+     ULONG valid;
+     register int c = get_processor_id();
+
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
+     if (!valid)
+     {
+        register int found = 0;
+
+	for (i=0; i < 4; i++)
+	{
+	   if (BreakReserved[i])
+	   {
+	      symbolName = GetSymbolFromValue(BreakPoints[i], &symbuf[c][0],
+                                           MAX_SYMBOL_LEN);
+	      moduleName = GetModuleInfoFromSymbolValue(BreakPoints[i],
+                                           &modbuf[c][0], MAX_SYMBOL_LEN);
+              if (moduleName)
+	         DBGPrint("Break %i is at 0x%08X (%s %s) %s|%s\n",
+				(int)i,
+				(unsigned)BreakPoints[i],
+				BreakDescription[(BreakType[i] & 3)],
+				BreakLengthDescription[(BreakLength[i] & 3)],
+			        ((char *)(moduleName) ? (char *)(moduleName)
+                                : (char *)("")),
+			        ((char *)(symbolName) ? (char *)(symbolName)
+                                : (char *)("")));
+              else
+	         DBGPrint("Break %i is at 0x%08X (%s %s) %s\n",
+				(int)i,
+				(unsigned)BreakPoints[i],
+				BreakDescription[(BreakType[i] & 3)],
+				BreakLengthDescription[(BreakLength[i] & 3)],
+			        ((char *)(symbolName) ? (char *)(symbolName)
+                                : (char *)("")));
+
+	      if (ConditionalBreakpoint[i])
+		 DBGPrint("if (%s) is TRUE\n", BreakCondition[i]);
+              found = TRUE;
+	   }
+	}
+        if (!found)
+           DBGPrint("no breakpoints currently defined\n");
+
+     }
+     else
+     {
+	for (i=0; i < 4; i++)
+	{
+	   if (!BreakReserved[i])
+	   {
+	      pB = cmd;
+	      EvaluateExpression(stackFrame, &cmd, &valid);
+	      if (valid)
+	      {
+		 ConditionalBreakpoint[i] = 1;
+		 for (r=0; r < 255 && *pB; r++)
+		    BreakCondition[i][r] = *pB++;
+		 BreakCondition[i][r] = '\0';
+	      }
+	      BreakReserved[i] = 1;
+	      BreakPoints[i] = address;
+	      BreakType[i] = BREAK_EXECUTE;
+	      BreakLength[i] = ONE_BYTE_FIELD;
+	      symbolName = GetSymbolFromValue(address, &symbuf[c][0],
+                                           MAX_SYMBOL_LEN);
+	      moduleName = GetModuleInfoFromSymbolValue(address, &modbuf[c][0],
+                                           MAX_SYMBOL_LEN);
+              if (moduleName)
+	         DBGPrint("breakpoint %i set to 0x%08X (%s %s) %s|%s\n",
+				 (int)i,
+				 (unsigned)BreakPoints[i],
+				 BreakDescription[(BreakType[i] & 3)],
+				 BreakLengthDescription[(BreakLength[i] & 3)],
+			        ((char *)(moduleName) ? (char *)(moduleName)
+                                 : (char *)("")),
+			         ((char *)(symbolName) ? (char *)(symbolName)
+                                 : (char *)("")));
+              else
+	         DBGPrint("breakpoint %i set to 0x%08X (%s %s) %s\n",
+				 (int)i,
+				 (unsigned)BreakPoints[i],
+				 BreakDescription[(BreakType[i] & 3)],
+				 BreakLengthDescription[(BreakLength[i] & 3)],
+			         ((char *)(symbolName) ? (char *)(symbolName)
+                                 : (char *)("")));
+
+	      if (ConditionalBreakpoint[i])
+		 DBGPrint("if (%s) is TRUE\n", BreakCondition[i]);
+
+	      SetDebugRegisters();
+	      return TRUE;
+	   }
+	}
+	DBGPrint("no breakpoint available\n");
+     }
+     return TRUE;
+
+}
+
+// BST
+
+ULONG breakpointShowTemp(BYTE *cmd,
+			StackFrame *stackFrame, ULONG Exception,
+			DEBUGGER_PARSER *parser)
+{
+     register ULONG i;
+     register BYTE *symbolName;
+     register BYTE *moduleName;
+     register int found = 0;
+     register int c = get_processor_id();
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     for (i=0; i < 4; i++)
+     {
+	if (BreakReserved[i] && BreakTemp[i])
+	{
+	   symbolName = GetSymbolFromValue(BreakPoints[i], &symbuf[c][0],
+                                           MAX_SYMBOL_LEN);
+	   moduleName = GetModuleInfoFromSymbolValue(BreakPoints[i],
+                                           &modbuf[c][0], MAX_SYMBOL_LEN);
+           if (moduleName)
+	      DBGPrint("Break %i is at 0x%08X (%s %s) %s|%s [%s]\n",
+				(int)i,
+				(unsigned)BreakPoints[i],
+				BreakDescription[(BreakType[i] & 3)],
+				BreakLengthDescription[(BreakLength[i] & 3)],
+			       ((char *)(moduleName) ? (char *)(moduleName)
+                                : (char *)("")),
+			        ((char *)(symbolName) ? (char *)(symbolName)
+                                : (char *)("")),
+				BreakGo[i] ? "GO" : BreakProceed[i]
+                                ? "PROCEED" : "");
+           else
+	      DBGPrint("Break %i is at 0x%08X (%s %s) %s [%s]\n",
+				(int)i,
+				(unsigned)BreakPoints[i],
+				BreakDescription[(BreakType[i] & 3)],
+				BreakLengthDescription[(BreakLength[i] & 3)],
+			        ((char *)(symbolName) ? (char *)(symbolName)
+                                : (char *)("")),
+				BreakGo[i] ? "GO" : BreakProceed[i]
+                                ? "PROCEED" : "");
+	   if (ConditionalBreakpoint[i])
+	      DBGPrint("if (%s) is TRUE\n", BreakCondition[i]);
+
+           found = TRUE;
+	}
+     }
+     if (!found)
+        DBGPrint("no temporary breakpoints defined\n");
+
+     return TRUE;
+
+}
+
+ULONG displayProcessorStatusHelp(BYTE *commandLine, DEBUGGER_PARSER *parser)
+{
+    if (commandLine) {}
+    if (parser) {}
+
+    mdb_printf("displays active processors and their current state\n");
+    return TRUE;
+}
+
+ULONG displayProcessorStatus(BYTE *cmd,
+		       StackFrame *stackFrame, ULONG Exception,
+		       DEBUGGER_PARSER *parser)
+{
+     register ULONG i;
+
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     for (i=0; i < MAX_PROCESSORS; i++)
+     {
+        if (cpu_online(i))
+        {
+	   mdb_printf("Processor: (%i)  State:  %s\n",
+	              i, procState[ProcessorState[i] & 0xF]);
+        }
+     }
+     return TRUE;
+}
+
+void displayMTRRRegisters(void)
+{
+    register int i;
+    ULONG base1, base2;
+    ULONG mask1, mask2;
+    extern ULONG cpu_mttr_on(void);
+
+    if (cpu_mttr_on())
+    {
+       DBGPrint("memory type range registers\n");
+       for (i = 0; i < 8; i++)
+       {
+	  ReadMSR(MTRR_BASE_REGS[i], &base1, &base2);
+	  ReadMSR(MTRR_MASK_VALUES[i], &mask1, &mask2);
+	  DBGPrint("MTRR_BASE_%i  %08X:%08X   MTRR_MASK_%i  %08X:%08X\n",
+			   (int)i,
+                           (unsigned)base1, (unsigned)base2,
+                           (int)i,
+                           (unsigned)mask1, (unsigned)mask2);
+       }
+    }
+    else
+       DBGPrint("memory type range registers are Pentium Pro/II/Xeon and
above\n");
+    return;
+}
+
+void DisplayGDT(BYTE *GDT_ADDRESS)
+{
+
+    register int i, r;
+    ULONG count;
+    ULONG gdt_pointer;
+    WORD gdt_index;
+    BYTE *p;
+    BYTE GDTR[8];
+    GDT *gdt;
+    TSS *tss;
+    union
+    {
+       GDT lgdt;
+       BYTE data[8];
+    } lg;
+
+    ReadGDTR((ULONG *)&GDTR[0]);
+    gdt_index = mdb_getword((ULONG)&GDTR[0], 2);
+    gdt_pointer = mdb_getword((ULONG)&GDTR[2], 4);
+
+    DBGPrint("GDTR: %04X:%08X  Processor: %i\n",
+                  (unsigned)gdt_index, (unsigned)gdt_pointer,
+                  (int)get_processor_id());
+
+    count = 0;
+    gdt_index = (gdt_index + 7) / 8;
+    p = (BYTE *) gdt_pointer;
+    for (i=0; i < gdt_index; i++)
+    {
+       if (DBGPrint("%08X (%04i):", (unsigned) count, (int)i)) return;
+       for (r=0; r < 8; r++)
+       {
+	  lg.data[r] = (BYTE) mdb_getword((ULONG)&p[r], 1);
+	  if (DBGPrint(" %02X", (BYTE) lg.data[r])) return;
+       }
+
+       gdt = (GDT *) &lg.lgdt;
+       if ((gdt->GDTType & 0x92) == 0x92)
+       {
+	  if (DBGPrint("  b:%08X lim:%08X t:%02X ot:%02X",
+		   ((gdt->Base3 << 24) | (gdt->Base2 << 16) |
+                   (gdt->Base1)),
+		   (((gdt->OtherType & 0xF) << 16) | (gdt->Limit)),
+		   gdt->GDTType, gdt->OtherType)) return;
+       }
+       else if ((gdt->GDTType & 0x89) == 0x89)
+       {
+	  tss = (TSS *) gdt;
+	  if (DBGPrint("  tss:%08X lim:%04X t:%02X ot:%02X",
+		      ((tss->TSSBase3 << 24) | (tss->TSSBase2 << 16) |
+                      (tss->TSSBase1)),
+		      tss->TSSLimit, tss->TSSType,
+                      tss->TSSOtherType)) return;
+       }
+       if (DBGPrint("\n")) return;
+
+       p = (void *)((ULONG) p + (ULONG) 8);
+       count += 8;
+    }
+
+    return;
+
+}
+
+void DisplayIDT(BYTE *IDT_ADDRESS)
+{
+
+    register int i, r;
+    ULONG count;
+    ULONG idt_pointer;
+    WORD idt_index;
+    BYTE *p;
+    BYTE IDTR[8];
+    IDT *idt;
+    TSS_GATE *tss_gate;
+    union
+    {
+       IDT lidt;
+       BYTE data[8];
+    } id;
+
+    ReadIDTR((ULONG *)&IDTR[0]);
+    idt_index = mdb_getword((ULONG)&IDTR[0], 2);
+    idt_pointer = mdb_getword((ULONG)&IDTR[2], 4);
+
+    DBGPrint("IDTR: %04X:%08X  Processor: %i\n",
+                    (unsigned)idt_index, (unsigned)idt_pointer,
+                    (int)get_processor_id());
+
+    count = 0;
+    idt_index = (idt_index + 7) / 8;
+    p = (BYTE *) idt_pointer;
+    for (i=0; i < idt_index; i++)
+    {
+       if (DBGPrint("%08X (%04i):", (unsigned)count, (int)i)) return;
+       for (r=0; r < 8; r++)
+       {
+	   id.data[r] = mdb_getword((ULONG)&p[r], 1);
+	   if (DBGPrint(" %02X", (BYTE) id.data[r])) return;
+       }
+       idt = (IDT *) &id.lidt;
+       if ((idt->IDTFlags & 0x8E) == 0x8E)
+       {
+	  if (DBGPrint("  b:%08X s:%04X t:%02X ot:%02X",
+			     ((idt->IDTHigh << 16) | (idt->IDTLow)),
+			     idt->IDTSegment,
+			     idt->IDTFlags, idt->IDTSkip)) return;
+
+       }
+       else if ((idt->IDTFlags & 0x85) == 0x85)
+       {
+	  tss_gate = (TSS_GATE *) idt;
+	  if (DBGPrint("  task_gate: %04X t:%02X",
+		     tss_gate->TSSSelector, tss_gate->TSSFlags)) return;
+       }
+       if (DBGPrint("\n")) return;
+
+       p = (void *)((ULONG) p + (ULONG) 8);
+       count += 8;
+    }
+
+    return;
+
+}
+
+void DisplayTSS(StackFrame *stackFrame)
+{
+
+    ULONG i, f = 0;
+
+    DBGPrint("Task State Segment at 0x%08X\n",
+        (unsigned)stackFrame);
+
+    DBGPrint("LDT: %08X  CR3: %08X  IOMAP: %08X  BLINK: %08X\n",
+	(unsigned)stackFrame->tLDT,
+        (unsigned)stackFrame->tCR3,
+        (unsigned)stackFrame->tIOMap,
+        (unsigned)stackFrame->tReserved[0]);
+
+    DBGPrint("CS: %04X  DS: %04X  ES: %04X  FS: %04X  GS: %04X  SS: %04X\n",
+       (unsigned)stackFrame->tCS,
+       (unsigned)stackFrame->tDS,
+       (unsigned)stackFrame->tES,
+       (unsigned)stackFrame->tFS,
+       (unsigned)stackFrame->tGS,
+       (unsigned)stackFrame->tSS);
+
+    DBGPrint("EAX: %08X  EBX: %08X  ECX: %08X  EDX: %08X\n",
+       (unsigned)stackFrame->tEAX,
+       (unsigned)stackFrame->tEBX,
+       (unsigned)stackFrame->tECX,
+       (unsigned)stackFrame->tEDX);
+
+    DBGPrint("ESI: %08X  EDI: %08X  ESP: %08X  EBP: %08X\n",
+       (unsigned)stackFrame->tESI,
+       (unsigned)stackFrame->tEDI,
+       (unsigned)stackFrame->tESP,
+       (unsigned)stackFrame->tEBP);
+
+    DBGPrint("EIP: %08X  FLAGS: %08X ",
+       (unsigned)stackFrame->tEIP,
+       (unsigned)stackFrame->tSystemFlags);
+
+    DBGPrint(" (");
+    for (i=0; i < 22; i++)
+    {
+       if (IA32Flags[i])
+       {
+	  if ((stackFrame->tSystemFlags >> i) & 0x00000001)
+	  {
+	     if (f)
+		DBGPrint(" ");
+	     f = 1;
+	     DBGPrint("%s", IA32Flags[i]);
+	  }
+       }
+    }
+    DBGPrint(")\n");
+
+
+}
+
+void DisplayGeneralRegisters(StackFrame *stackFrame)
+{
+
+    ULONG i, f = 0;
+
+    DBGPrint("EAX: %08X ", (unsigned)stackFrame->tEAX);
+    DBGPrint("EBX: %08X ", (unsigned)stackFrame->tEBX);
+    DBGPrint("ECX: %08X ", (unsigned)stackFrame->tECX);
+    DBGPrint("EDX: %08X\n", (unsigned)stackFrame->tEDX);
+    DBGPrint("ESI: %08X ", (unsigned)stackFrame->tESI);
+    DBGPrint("EDI: %08X ", (unsigned)stackFrame->tEDI);
+    DBGPrint("ESP: %08X ", (unsigned)stackFrame->tESP);
+    DBGPrint("EBP: %08X\n", (unsigned)stackFrame->tEBP);
+
+    if (segment_toggle)
+       DisplaySegmentRegisters(stackFrame);
+
+    DBGPrint("EIP: %08X ", (unsigned)stackFrame->tEIP);
+    DBGPrint("ORGEAX: %08X ", (unsigned)stackFrame->tReserved[1]);
+    DBGPrint("EFLAGS: %08X ", (unsigned)stackFrame->tSystemFlags);
+
+    DBGPrint(" (");
+    for (i=0; i < 22; i++)
+    {
+       if (IA32Flags[i])
+       {
+	  if ((stackFrame->tSystemFlags >> i) & 0x00000001)
+	  {
+	     if (f)
+		DBGPrint(" ");
+	     f = 1;
+	     DBGPrint("%s", IA32Flags[i]);
+	  }
+       }
+    }
+    DBGPrint(")\n");
+
+}
+
+void DisplaySegmentRegisters(StackFrame *stackFrame)
+{
+
+    DBGPrint("CS: %04X ", (unsigned)stackFrame->tCS);
+    DBGPrint("DS: %04X ", (unsigned)stackFrame->tDS);
+    DBGPrint("ES: %04X ", (unsigned)stackFrame->tES);
+    DBGPrint("FS: %04X ", (unsigned)stackFrame->tFS);
+    DBGPrint("GS: %04X ", (unsigned)stackFrame->tGS);
+    DBGPrint("SS: %04X\n", (unsigned)stackFrame->tSS);
+
+}
+
+void DisplayControlRegisters(ULONG processor, StackFrame *stackFrame)
+{
+
+    BYTE GDTR[8], IDTR[8];
+
+    if (stackFrame) {};
+
+    DBGPrint("CR0: %08X ", (unsigned)ReadCR0());
+    DBGPrint("CR2: %08X ", (unsigned)ReadCR2());
+    DBGPrint("CR3: %08X ", (unsigned)ReadCR3());
+    DBGPrint("CR4: %08X\n", (unsigned)ReadCR4());
+    DBGPrint("DR0: %08X ", (unsigned)ReadDR0());
+    DBGPrint("DR1: %08X ", (unsigned)ReadDR1());
+    DBGPrint("DR2: %08X ", (unsigned)ReadDR2());
+    DBGPrint("DR3: %08X\n", (unsigned)ReadDR3());
+    DBGPrint("DR6: %08X ", (unsigned)ReadDR6());
+    DBGPrint("DR7: %08X ", (unsigned)ReadDR7());
+    DBGPrint("VR6: %08X ", (unsigned)CurrentDR6[processor]);
+    DBGPrint("VR7: %08X\n", (unsigned)CurrentDR7);
+
+    ReadGDTR((ULONG *)&GDTR[0]);
+    ReadIDTR((ULONG *)&IDTR[0]);
+    DBGPrint("GDTR: %04X:%08X IDTR: %04X:%08X  LDTR: %04X  TR: %04X\n",
+			(unsigned)*(WORD *)&GDTR[0],
+                        (unsigned)*(ULONG *)&GDTR[2],
+			(unsigned)*(WORD *)&IDTR[0],
+                        (unsigned)*(ULONG *)&IDTR[2],
+			(unsigned)ReadLDTR(),
+                        (unsigned)ReadTR());
+
+}
+
+ULONG ConsoleDisplayBreakReason(StackFrame *stackFrame, ULONG Exception,
+                                ULONG processor, ULONG lastCommand)
+{
+       if (last_mdb_oops)
+          DBGPrint("\nKernel Oops reported (%s)\n", last_mdb_oops);
+
+       if ((CurrentDR6[processor] & B0_BIT) && (CurrentDR7 & G0_BIT) &&
+            Exception == 1)
+       {
+	  if (BreakGo[0])
+          {
+	     DBGPrint("\nBreak at 0x%08X due to - GO breakpoint (0)\n",
+				 (unsigned)stackFrame->tEIP);
+             return 1;
+          }
+	  else
+          if (BreakProceed[0])
+          {
+	     DBGPrint("\nBreak at 0x%08X due to - Proceed breakpoint (0)\n",
+				 (unsigned)stackFrame->tEIP);
+             return 1;
+          }
+	  else
+          if (BreakPoints[0] && ConditionalBreakpoint[0])
+	  {
+	     DBGPrint("\nBreak at 0x%08X due to - breakpoint 0 (%s)\n",
+				 (unsigned)stackFrame->tEIP,
+                                 BreakDescription[(BreakType[0] & 3)]);
+	     DBGPrint("expr: %s was TRUE\n", BreakCondition[0]);
+             return 1;
+	  }
+	  else
+          if (BreakPoints[0])
+          {
+	     DBGPrint("\nBreak at 0x%08X due to - breakpoint 0 (%s)\n",
+				 (unsigned)stackFrame->tEIP,
+                                 BreakDescription[(BreakType[0] & 3)]);
+             return 1;
+          }
+          else
+             return 0;  // not one of ours
+       }
+       else
+       if ((CurrentDR6[processor] & B1_BIT) && (CurrentDR7 & G1_BIT) &&
+            Exception == 1)
+       {
+	  if (BreakGo[1])
+          {
+	     DBGPrint("\nBreak at 0x%08X due to - GO breakpoint (1)\n",
+				 (unsigned)stackFrame->tEIP);
+             return 1;
+          }
+	  else
+          if (BreakProceed[1])
+          {
+	     DBGPrint("\nBreak at 0x%08X due to - Proceed breakpoint (1)\n",
+				 (unsigned)stackFrame->tEIP);
+             return 1;
+          }
+	  else
+          if (BreakPoints[1] && ConditionalBreakpoint[1])
+	  {
+	     DBGPrint("\nBreak at 0x%08X due to - breakpoint 1 (%s)\n",
+				 (unsigned)stackFrame->tEIP,
+                                 BreakDescription[(BreakType[1] & 3)]);
+	     DBGPrint("expr: %s was TRUE\n", BreakCondition[1]);
+             return 1;
+	  }
+	  else
+          if (BreakPoints[1])
+          {
+	     DBGPrint("\nBreak at 0x%08X due to - breakpoint 1 (%s)\n",
+				 (unsigned)stackFrame->tEIP,
+                                 BreakDescription[(BreakType[1] & 3)]);
+             return 1;
+          }
+          else
+             return 0;  // not one of ours
+       }
+       else
+       if ((CurrentDR6[processor] & B2_BIT) && (CurrentDR7 & G2_BIT) &&
+            Exception == 1)
+       {
+	  if (BreakGo[2])
+          {
+	     DBGPrint("\nBreak at 0x%08X due to - GO breakpoint (2)\n",
+				 (unsigned)stackFrame->tEIP);
+             return 1;
+          }
+	  else
+          if (BreakProceed[2])
+          {
+	     DBGPrint("\nBreak at 0x%08X due to - Proceed breakpoint (2)\n",
+				 (unsigned)stackFrame->tEIP);
+             return 1;
+          }
+	  else
+          if (BreakPoints[2] && ConditionalBreakpoint[2])
+	  {
+	     DBGPrint("\nBreak at 0x%08X due to - breakpoint 2 (%s)\n",
+				 (unsigned)stackFrame->tEIP,
+                                 BreakDescription[(BreakType[2] & 3)]);
+	     DBGPrint("expr: %s was TRUE\n", BreakCondition[2]);
+             return 1;
+	  }
+	  else
+          if (BreakPoints[2])
+          {
+	     DBGPrint("\nBreak at 0x%08X due to - breakpoint 2 (%s)\n",
+				 (unsigned)stackFrame->tEIP,
+                                 BreakDescription[(BreakType[2] & 3)]);
+             return 1;
+          }
+          else
+             return 0;  // not one of ours
+       }
+       else
+       if ((CurrentDR6[processor] & B3_BIT) && (CurrentDR7 & G3_BIT) &&
+            Exception == 1)
+       {
+	  if (BreakGo[3])
+          {
+	     DBGPrint("\nBreak at 0x%08X due to - GO breakpoint (3)\n",
+				 (unsigned)stackFrame->tEIP);
+             return 1;
+          }
+	  else
+          if (BreakProceed[3])
+          {
+	     DBGPrint("\nBreak at 0x%08X due to - Proceed breakpoint (3)\n",
+				 (unsigned)stackFrame->tEIP);
+             return 1;
+          }
+	  else
+          if (BreakPoints[3] && ConditionalBreakpoint[3])
+	  {
+	     DBGPrint("\nBreak at 0x%08X due to - breakpoint 3 (%s)\n",
+				 (unsigned)stackFrame->tEIP,
+                                 BreakDescription[(BreakType[3] & 3)]);
+	     DBGPrint("expr: %s was TRUE\n", BreakCondition[3]);
+             return 1;
+	  }
+	  else
+          if (BreakPoints[3])
+          {
+	     DBGPrint("\nBreak at 0x%08X due to - breakpoint 3 (%s)\n",
+				 (unsigned)stackFrame->tEIP,
+                                 BreakDescription[(BreakType[3] & 3)]);
+             return 1;
+          }
+          else
+             return 0;  // not one of ours
+       }
+       else
+       {
+	  // if the last command was a Proceed that was converted into a
+	  // single step command, report proceed single step
+	  if (lastCommandEntry == 'P' && Exception == 1)
+          {
+	     DBGPrint("\nBreak at 0x%08X due to - Proceed (single step)\n",
+                      (unsigned)stackFrame->tEIP);
+             return 1;
+          }
+	  else
+          if (lastCommandEntry == 'T' && Exception == 1)
+          {
+	     DBGPrint("\nBreak at 0x%08X due to - Trace (single step)\n",
+                      (unsigned)stackFrame->tEIP);
+             return 1;
+          }
+          else
+	  if (lastCommandEntry == K_F8 && Exception == 1)
+          {
+	     DBGPrint("\nBreak at 0x%08X due to - Proceed (single step)\n",
+                      (unsigned)stackFrame->tEIP);
+             return 1;
+          }
+	  else
+          if (lastCommandEntry == K_F7 && Exception == 1)
+          {
+	     DBGPrint("\nBreak at 0x%08X due to - Trace (single step)\n",
+                      (unsigned)stackFrame->tEIP);
+             return 1;
+          }
+	  else
+          if (lastCommandEntry == K_F6 && Exception == 1)
+          {
+	     DBGPrint("\nBreak at 0x%08X due to - Step (single step)\n",
+                      (unsigned)stackFrame->tEIP);
+             return 1;
+          }
+          else
+          if (Exception == 3)  // not our exception
+          {
+	     DBGPrint("\nBreak at 0x%08X due to - INT3 breakpoint\n",
+				 (unsigned)stackFrame->tEIP);
+             return 1;
+          }
+          else
+          if (Exception == 1)  // not our exception, must be gdb
+          {
+             return 0;
+          }
+	  else
+          if ((Exception < exceptions) &&
+              ExceptionDescription[Exception % exceptions])
+          {
+	     DBGPrint("\nBreak at 0x%08X due to - %s\n",
+                    (unsigned)stackFrame->tEIP,
+                    ExceptionDescription[Exception % exceptions]);
+             return 1;
+          }
+          else
+          {
+	     DBGPrint("\nBreak at 0x%08X due to - %lu\n",
+                    (unsigned)stackFrame->tEIP, Exception);
+             return 1;
+          }
+       }
+       return 0;
+
+}
+
+ULONG ReasonHelp(BYTE *commandLine, DEBUGGER_PARSER *parser)
+{
+    if (commandLine) {}
+    if (parser) {}
+
+    mdb_printf("display break reason\n");
+    return TRUE;
+}
+
+ULONG ReasonDisplay(BYTE *cmd,
+		    StackFrame *stackFrame, ULONG Exception,
+		    DEBUGGER_PARSER *parser)
+{
+     if (cmd) {};
+     if (stackFrame) {};
+     if (Exception) {};
+     if (parser) {};
+
+     ConsoleDisplayBreakReason(stackFrame, Exception, get_processor_id(),
0);
+     return TRUE;
+}
+
+void ReadStackFrame(void *frame, StackFrame *sf, ULONG processor)
+{
+   struct pt_regs *regs = frame;
+
+   sf->tCR3 = (ULONG *)ReadCR3();
+   sf->tEIP = regs->ip;
+   sf->tSystemFlags = regs->flags;
+   sf->tReserved[1] = regs->orig_ax;
+   sf->tReserved[2] = (ULONG)regs;
+   sf->tEAX = regs->ax;
+   sf->tECX = regs->cx;
+   sf->tEDX = regs->dx;
+   sf->tEBX = regs->bx;
+   sf->tEBP = regs->bp;
+   sf->tESI = regs->si;
+   sf->tEDI = regs->di;
+   sf->tES = (WORD)regs->es;
+   sf->tCS = (WORD)regs->cs;
+   sf->tDS = (WORD)regs->ds;
+   sf->tFS = (ReadFS() & 0xFFFF);
+   sf->tGS = (ReadGS() & 0xFFFF);
+   sf->tLDT = (ReadLDTR() & 0xFFFF);
+   if ((regs->cs & 0xffff) == __KERNEL_CS)
+   {
+      sf->tESP = (ULONG)((ULONG)regs + sizeof(struct pt_regs) - 2*4);
+      asm volatile("pushl %%ss\n"
+		   "popl %0\n"
+                  :"=m" (sf->tSS));
+      sf->tSS &= 0xFFFF;
+   }
+   else
+   {
+      sf->tESP = regs->sp;
+      sf->tSS = (WORD)regs->ss;
+   }
+   // save state.
+   memmove((void *)&ReferenceFrame[processor], sf, sizeof(StackFrame));
+   return;
+}
+
+void WriteStackFrame(void *frame, StackFrame *sf, ULONG processor)
+{
+   struct pt_regs *regs = frame;
+
+   if (ReferenceFrame[processor].tEIP != sf->tEIP)
+      regs->ip = sf->tEIP;
+   if (ReferenceFrame[processor].tSystemFlags != sf->tSystemFlags)
+      regs->flags = sf->tSystemFlags;
+   if (ReferenceFrame[processor].tReserved[1] != sf->tReserved[1])
+      regs->orig_ax = sf->tReserved[1];
+   if (ReferenceFrame[processor].tEAX != sf->tEAX)
+      regs->ax = sf->tEAX;
+   if (ReferenceFrame[processor].tECX != sf->tECX)
+      regs->cx = sf->tECX;
+   if (ReferenceFrame[processor].tEDX != sf->tEDX)
+      regs->dx = sf->tEDX;
+   if (ReferenceFrame[processor].tEBX != sf->tEBX)
+      regs->bx = sf->tEBX;
+   if (ReferenceFrame[processor].tESP != sf->tESP)
+      regs->sp = sf->tESP;
+   if (ReferenceFrame[processor].tEBP != sf->tEBP)
+      regs->bp = sf->tEBP;
+   if (ReferenceFrame[processor].tESI != sf->tESI)
+      regs->si = sf->tESI;
+   if (ReferenceFrame[processor].tEDI != sf->tEDI)
+      regs->di = sf->tEDI;
+   if (ReferenceFrame[processor].tES != sf->tES)
+      regs->es = sf->tES;
+   if (ReferenceFrame[processor].tCS != sf->tCS)
+      regs->cs = sf->tCS;
+   if (ReferenceFrame[processor].tSS != sf->tSS)
+      regs->ss = sf->tSS;
+   if (ReferenceFrame[processor].tDS != sf->tDS)
+      regs->ds = sf->tDS;
+   return;
+}
+
+void SetDebugRegisters(void)
+{
+   register int i;
+
+   for (i=0; i < 4; i++)
+   {
+      switch (i)
+      {
+	 case 0:
+	    if (BreakReserved[i])
+	    {
+	       CurrentDR7 &= 0xFFF0FFFF;
+	       CurrentDR7 |= G0_BIT;
+	       CurrentDR7 |= ((BreakType[i] << ((i * 4) + 16)) |
+			      (BreakLength[i] << ((i * 4) + 18)));
+	    }
+	    else
+	    {
+	       CurrentDR7 &= 0xFFF0FFFF;
+	       CurrentDR7 &= ~G0_BIT;
+	       CurrentDR7 &= ~L0_BIT;
+	    }
+	    WriteDR0(BreakPoints[i]);
+	    break;
+
+	 case 1:
+	    if (BreakReserved[i])
+	    {
+	       CurrentDR7 &= 0xFF0FFFFF;
+	       CurrentDR7 |= G1_BIT;
+	       CurrentDR7 |= ((BreakType[i] << ((i * 4) + 16)) |
+			      (BreakLength[i] << ((i * 4) + 18)));
+	    }
+	    else
+	    {
+	       CurrentDR7 &= 0xFF0FFFFF;
+	       CurrentDR7 &= ~G1_BIT;
+	       CurrentDR7 &= ~L1_BIT;
+	    }
+	    WriteDR1(BreakPoints[i]);
+	    break;
+
+	 case 2:
+	    if (BreakReserved[i])
+	    {
+	       CurrentDR7 &= 0xF0FFFFFF;
+	       CurrentDR7 |= G2_BIT;
+	       CurrentDR7 |= ((BreakType[i] << ((i * 4) + 16)) |
+			      (BreakLength[i] << ((i * 4) + 18)));
+	    }
+	    else
+	    {
+	       CurrentDR7 &= 0xF0FFFFFF;
+	       CurrentDR7 &= ~G2_BIT;
+	       CurrentDR7 &= ~L2_BIT;
+	    }
+	    WriteDR2(BreakPoints[i]);
+	    break;
+
+	 case 3:
+	    if (BreakReserved[i])
+	    {
+	       CurrentDR7 &= 0x0FFFFFFF;
+	       CurrentDR7 |= G3_BIT;
+	       CurrentDR7 |= ((BreakType[i] << ((i * 4) + 16)) |
+			      (BreakLength[i] << ((i * 4) + 18)));
+	    }
+	    else
+	    {
+	       CurrentDR7 &= 0x0FFFFFFF;
+	       CurrentDR7 &= ~G3_BIT;
+	       CurrentDR7 &= ~L3_BIT;
+	    }
+	    WriteDR3(BreakPoints[i]);
+	    break;
+
+      }
+   }
+   return;
+
+}
+
+void LoadDebugRegisters(void)
+{
+
+   register int i;
+
+   WriteDR6(0);  // clear last exception status
+   for (i=0; i < 4; i++)
+   {
+      switch (i)
+      {
+	 case 0:
+	    if (BreakReserved[i])
+	       WriteDR0(BreakPoints[i]);
+	    break;
+
+	 case 1:
+	    if (BreakReserved[i])
+	       WriteDR1(BreakPoints[i]);
+	    break;
+
+	 case 2:
+	    if (BreakReserved[i])
+	       WriteDR2(BreakPoints[i]);
+	    break;
+
+	 case 3:
+	    if (BreakReserved[i])
+	       WriteDR3(BreakPoints[i]);
+	    break;
+      }
+   }
+   WriteDR7(CurrentDR7);  // set breakpoint enable/disable state
+
+}
+
+//
+//   returns   0 - atomic lock occurred, processor assigned
+//             1 - recusive count increased
+//
+
+ULONG rspin_lock(volatile rlock_t *rlock)
+{
+#if defined(CONFIG_SMP)
+   register ULONG proc = get_processor_id();
+   register ULONG retCode;
+
+   if (rlock->lock.raw_lock.slock && rlock->processor == proc)
+   {
+      rlock->count++;
+      retCode = 1;
+   }
+   else
+   {
+      spin_lock_irqsave((spinlock_t *)&rlock->lock, rlock->flags);
+      rlock->processor = proc;
+      retCode = 0;
+   }
+   return retCode;
+#else
+   return 0;
+#endif
+}
+
+//
+//   returns   0 - lock released
+//             1 - recusive count decreased
+//
+
+ULONG rspin_unlock(volatile rlock_t *rlock)
+{
+#if defined(CONFIG_SMP)
+   register ULONG retCode;
+
+   if (rlock->count)
+   {
+      rlock->count--;
+      retCode = 1;
+   }
+   else
+   {
+      rlock->processor = -1;
+      spin_unlock_irqrestore((spinlock_t *)&rlock->lock, rlock->flags);
+      retCode = 0;
+   }
+   return retCode;
+#else
+   return 0;
+#endif
+}
+
+//
+//   returns   0 - atomic lock occurred, processor assigned
+//             1 - recusive count increased
+//            -1 - atomic try lock failed
+//
+
+ULONG rspin_try_lock(volatile rlock_t *rlock)
+{
+#if defined(CONFIG_SMP)
+   register ULONG proc = get_processor_id();
+   register ULONG retCode;
+
+   if (rlock->lock.raw_lock.slock && rlock->processor == proc)
+   {
+      rlock->count++;
+      retCode = 0;
+   }
+   else
+   {
+      spin_lock_irqsave((spinlock_t *)&rlock->lock, rlock->flags);
+      rlock->processor = proc;
+      retCode = 0;
+   }
+   return retCode;
+#else
+   return 0;
+#endif
+}
+
+ULONG debug_lock(volatile rlock_t *rlock, ULONG p)
+{
+    while (rspin_try_lock(rlock))
+    {
+       if (ProcessorState[p] == PROCESSOR_SHUTDOWN)
+	  return 0;
+    }
+    return 1;
+}
+
+void debug_unlock(volatile rlock_t *rlock)
+{
+    rspin_unlock(rlock);
+}
+
+int mdb_ipi_state(void)
+{
+   return ((ProcessorState[get_processor_id()] == PROCESSOR_IPI) ? 1 : 0);
+}
+
+ULONG StopProcessorsExclSelf(ULONG self)
+{
+#if defined(CONFIG_SMP)
+   register ULONG failed;
+   register ULONG count;
+   register int i;
+   extern void smp_mdb_stop(void);
+
+   for (i=0; i < MAX_PROCESSORS; i++)
+   {
+      if (cpu_online(i))
+      {
+         if (i != self)
+         {
+	    ProcessorHold[i] = TRUE;
+         }
+      }
+   }
+
+   // NMI the other processors
+   send_IPI_allbutself(NMI_VECTOR);
+
+   for (i=0, count=0, failed=0; i < MAX_PROCESSORS; i++)
+   {
+      if (cpu_online(i))
+      {
+         if (i != self)
+         {
+	    while (ProcessorState[i] != PROCESSOR_SUSPEND)
+	    {
+	       if (count++ > 0x1FFFFF)
+	       {
+	          failed++;
+		  mdb_printf("\nProcessor %i could not be halted\n", (int)i);
+		  break;
+	       }
+	    }
+         }
+      }
+   }
+   return (ULONG) failed;
+#else
+   return 0;
+#endif
+}
+
+ULONG FreeProcessorsExclSelf(ULONG self)
+{
+#if defined(CONFIG_SMP)
+   register int i;
+
+   for (i=0; i < MAX_PROCESSORS; i++)
+      ProcessorState[i] = PROCESSOR_RESUME;
+   return i;
+#else
+   return MAX_PROCESSORS;
+#endif
+
+}
+
+ULONG WaitRestartExclSelf(ULONG self)
+{
+#if defined(CONFIG_SMP)
+   register ULONG failed;
+   register ULONG count;
+   register int i;
+
+   for (i=0, count=0, failed=0; i < MAX_PROCESSORS; i++)
+   {
+      if (cpu_online(i))
+      {
+         if (i != self)
+         {
+	    while (ProcessorState[i] != PROCESSOR_ACTIVE)
+	    {
+	       if (count++ > 0x1FFFFF)
+	       {
+	          failed++;
+		  mdb_printf("\nProcessor %i could did not restart\n", (int)i);
+		  break;
+	       }
+	    }
+         }
+      }
+   }
+   return (ULONG) failed;
+#else
+   return 0;
+#endif
+}
+
+ULONG debugger_entry(ULONG Exception, StackFrame *stackFrame,
+                     ULONG processor)
+{
+    register ULONG retCode = TRUE;
+    BYTE *cmd;
+    ULONG valid;
+
+    ProcessorState[processor] = PROCESSOR_DEBUG;
+    CurrentFrame[processor] = stackFrame;
+
+    debuggerActive++;
+
+    WriteDR7(0);  // disable breakpoints while debugger is running
+    CurrentDR6[processor] = ReadDR6();
+
+    if (fpu_present())
+       save_npx(&npx[processor]);
+
+MDBLoop:;
+    switch (Exception)
+    {
+          case 1:// int 1 debug exception
+	    if (BreakMask[processor])
+	    {
+	       stackFrame->tSystemFlags &= ~SINGLE_STEP;
+	       stackFrame->tSystemFlags |= RESUME;
+	       break;
+	    }
+	    else
+	    if ((CurrentDR6[processor] & B0_BIT) &&
+                (CurrentDR7 & G0_BIT) &&
+                (ConditionalBreakpoint[0]))
+	    {
+	       cmd = (BYTE *)&BreakCondition[0][0];
+	       if (!EvaluateExpression(stackFrame, &cmd, &valid))
+	       {
+		  stackFrame->tSystemFlags &= ~SINGLE_STEP;
+		  stackFrame->tSystemFlags |= RESUME;
+		  break;
+	       }
+	    }
+	    else
+	    if ((CurrentDR6[processor] & B1_BIT) &&
+                (CurrentDR7 & G1_BIT) &&
+                (ConditionalBreakpoint[1]))
+	    {
+	       cmd = (BYTE *)&BreakCondition[1][0];
+	       if (!EvaluateExpression(stackFrame, &cmd, &valid))
+	       {
+		  stackFrame->tSystemFlags &= ~SINGLE_STEP;
+		  stackFrame->tSystemFlags |= RESUME;
+		  break;
+	       }
+	    }
+	    else
+	    if ((CurrentDR6[processor] & B2_BIT) &&
+                (CurrentDR7 & G2_BIT) &&
+                (ConditionalBreakpoint[2]))
+	    {
+	       cmd = (BYTE *)&BreakCondition[2][0];
+	       if (!EvaluateExpression(stackFrame, &cmd, &valid))
+	       {
+		  stackFrame->tSystemFlags &= ~SINGLE_STEP;
+		  stackFrame->tSystemFlags |= RESUME;
+		  break;
+	       }
+	    }
+	    else
+	    if ((CurrentDR6[processor] & B3_BIT) &&
+                (CurrentDR7 & G3_BIT) &&
+                (ConditionalBreakpoint[3]))
+	    {
+	       cmd = (BYTE *)&BreakCondition[3][0];
+	       if (!EvaluateExpression(stackFrame, &cmd, &valid))
+	       {
+		  stackFrame->tSystemFlags &= ~SINGLE_STEP;
+		  stackFrame->tSystemFlags |= RESUME;
+		  break;
+	       }
+	    }
+
+            if (debug_lock(&debug_mutex, processor))
+            {
+               if (!ProcessorMode[processor])
+	          StopProcessorsExclSelf(processor);
+
+	       debugger_command_entry(processor, Exception, stackFrame);
+
+               if (!ProcessorMode[processor])
+	          FreeProcessorsExclSelf(processor);
+
+               debug_unlock(&debug_mutex);
+            }
+	    break;
+
+
+	 case 3:// int 3 breakpoint
+	    if (BreakMask[processor])
+	    {
+	       stackFrame->tSystemFlags &= ~SINGLE_STEP;
+	       stackFrame->tSystemFlags |= RESUME;
+	       break;
+	    }
+
+            if (debug_lock(&debug_mutex, processor))
+            {
+               if (!ProcessorMode[processor])
+	          StopProcessorsExclSelf(processor);
+
+	       debugger_command_entry(processor, Exception, stackFrame);
+
+               if (!ProcessorMode[processor])
+	          FreeProcessorsExclSelf(processor);
+
+               debug_unlock(&debug_mutex);
+            }
+	    break;
+
+         case 2: // nmi
+            if (ProcessorHold[processor])  // hold processor if directed nmi
+            {
+               ProcessorHold[processor] = 0;
+ 	       ProcessorState[processor] = PROCESSOR_SUSPEND;
+               // processor suspend loop
+	       while ((ProcessorState[processor] != PROCESSOR_RESUME) &&
+	              (ProcessorState[processor] != PROCESSOR_SWITCH))
+               {
+   	          if ((ProcessorState[processor] == PROCESSOR_RESUME) ||
+	              (ProcessorState[processor] == PROCESSOR_SWITCH))
+                     break;
+               }
+
+               if (ProcessorState[processor] == PROCESSOR_SWITCH)
+               {
+   	          ProcessorState[processor] = PROCESSOR_DEBUG;
+                  if (debug_lock(&debug_mutex, processor))
+                  {
+	             debugger_command_entry(processor, 21, stackFrame);
+
+                     if (!ProcessorMode[processor])
+	                FreeProcessorsExclSelf(processor);
+
+                     debug_unlock(&debug_mutex);
+                  }
+               }
+               break;
+            }
+            else   // all other nmi exceptions fall through to here
+            if (debug_lock(&debug_mutex, processor))
+            {
+               if (!ProcessorMode[processor])
+	          StopProcessorsExclSelf(processor);
+
+	       debugger_command_entry(processor, Exception, stackFrame);
+
+               if (!ProcessorMode[processor])
+	          FreeProcessorsExclSelf(processor);
+
+               debug_unlock(&debug_mutex);
+            }
+            break;
+
+	 default:
+            if (debug_lock(&debug_mutex, processor))
+            {
+               if (!ProcessorMode[processor])
+	          StopProcessorsExclSelf(processor);
+
+	       debugger_command_entry(processor, Exception, stackFrame);
+
+               if (!ProcessorMode[processor])
+	          FreeProcessorsExclSelf(processor);
+
+               debug_unlock(&debug_mutex);
+            }
+	    break;
+    }
+
+    if (ProcessorHold[processor])
+    {
+       Exception = 2;
+       goto MDBLoop;
+    }
+
+    LoadDebugRegisters();
+
+    if (fpu_present())
+       load_npx(&npx[processor]);
+
+    if (debuggerActive)
+       debuggerActive--;
+
+    CurrentFrame[processor] = 0;
+    ProcessorState[processor] = PROCESSOR_ACTIVE;
+
+    return retCode;
+
+}
+
+void InitializeDebuggerRegisters(void)
+{
+   CurrentDR7 = (DR7DEF | GEXACT | LEXACT); // set mode to GLOBAL EXACT
+   WriteDR0(0);                      // clear out DR0-DR6
+   WriteDR1(0);
+   WriteDR2(0);
+   WriteDR3(0);
+   WriteDR6(0);
+   WriteDR7(CurrentDR7);            // set DR7 register
+}
+
+void ClearDebuggerRegisters(void)
+{
+   WriteDR0(0);   // clear out all breakpoints and breakpoint
+   WriteDR1(0);   // registers DR0-DR7
+   WriteDR2(0);
+   WriteDR3(0);
+   WriteDR6(0);
+   WriteDR7(0);
+}
+
+#endif
+


By making a contribution to this project, I certify that
the contribution was created in whole or in part by me and I
have the right to submit it under the open source license
indicated in the file.

Jeffrey Vernon Merkey



