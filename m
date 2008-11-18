Return-Path: <linux-kernel-owner+w=401wt.eu-S1752846AbYKRTZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846AbYKRTZb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 14:25:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778AbYKRTZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 14:25:17 -0500
Received: from mail.gmx.net ([213.165.64.20]:33305 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751935AbYKRTZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 14:25:16 -0500
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX18pfAwROIspqFTHDwEDBFNLeFNiX+61foAH0dClNk
	SiUTCdb0berEGn
From: Helge Deller <deller@gmx.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-serial@vger.kernel.org
Subject: struct uart_port has no member named 'sysrq'   (was: linux-next: parisc build failure)
Date: Tue, 18 Nov 2008 20:24:24 +0100
User-Agent: KMail/1.9.7
Cc: Kyle McMartin <kyle@mcmartin.ca>, linux-parisc@vger.kernel.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20081116231342.0cd747bd.sfr@canb.auug.org.au>
In-Reply-To: <20081116231342.0cd747bd.sfr@canb.auug.org.au>
X-Face: &[jmHH-Dw>Aj):"[/t-VasJu+(5eP`/LEckV7V"JV,!nBy[6(/?#8M>x`5xzg/7:FkM.l@=?utf-8?q?=0A=0913?=<&9'nfV3"OkD~P)@j{P2=(uB7J(){:CcrM2jZeA+IBq?FUTp3c8Y{t+k<95mZf~[v"=?utf-8?q?=27=3A=0A=09t?="f6wKtHUPFB&/]Z5^?9~IQs=16R;Pg"NS9JD=DK!ft&4b@=?utf-8?q?S=7E=26q/MfI3=3BqWqlg7Q1=3D=3DjS4=0A=099V5OJkm=24WQ=5Bdc=5E=5FY?=
 =?utf-8?q?=27=5DDvibvMjizUZ=5D+=27Jd4UnM?=><yrT}Rw(
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200811182024.24781.deller@gmx.de>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 16 November 2008, Stephen Rothwell wrote:
> Hi Kyle,
> 
> Today's linux-next build (parisc allmodconfig) failed like this:
> 
> In file included from drivers/serial/mux.c:38:
> include/linux/serial_core.h: In function 'uart_handle_sysrq_char':
> include/linux/serial_core.h:450: error: 'struct uart_port' has no member named 'sysrq'
> include/linux/serial_core.h:451: error: 'struct uart_port' has no member named 'sysrq'
> include/linux/serial_core.h:451: error: 'struct uart_port' has no member named 'sysrq'
> include/linux/serial_core.h:453: error: 'struct uart_port' has no member named 'sysrq'
> include/linux/serial_core.h:456: error: 'struct uart_port' has no member named 'sysrq'
> include/linux/serial_core.h:473: error: 'struct uart_port' has no member named 'sysrq'
> include/linux/serial_core.h:474: error: 'struct uart_port' has no member named 'sysrq'
> include/linux/serial_core.h:477: error: 'struct uart_port' has no member named 'sysrq'
> 
> This is happening in mainline as well. In fact, this has been happening
> back as far as I have results (Aug 27).  The sysrq element of struct
> uart_port is dependent on CONFIG_SERIAL_CORE_CONSOLE while the references
> failing above are dependent on SUPPORT_SYSRQ which is defined if
> CONFIG_MAGIC_SYSRQ is defined in mux.c.

I assume you don't have CONFIG_SERIAL_CORE_CONSOLE set in your config, which is probably why this build failure shows up.
Looking at other serial drivers, which all seem to have similiar coding like mux.c, I'm wondering that it only shows up on parisc.

Anyway, since I assume we can't make the sysrq element of struct uart_port depended on SUPPORT_SYSRQ (since it depends on each serial driver if it wants to support the sysrq feature and we need to keep the size of struct uart_port constant), I think we need to add an additional check for CONFIG_SERIAL_CORE_CONSOLE to where we already check for SUPPORT_SYSRQ. 
Proposed patch and RFC below.

-------

[RFC] [PATCH] check for SUPPORT_SYSRQ and CONFIG_SERIAL_CORE_CONSOLE before accessing the "sysrq" member of struct uart_port.

Serial drivers (like mux.c) can #define SUPPORT_SYSRQ to tell the core serial functions that they want to have SYSRQ-support built-in.
If SUPPORT_SYSRQ is defined, the functions uart_handle_sysrq_char() and uart_handle_break() in include/linux/serial_core.h unconditionally access the "sysrq" member of struct uart_port.
Since the "sysrq" member of struct uart_port is only compiled into the kernel if CONFIG_SERIAL_CORE_CONSOLE is defined, builds will break if
SUPPORT_SYSRQ is defined and CONFIG_SERIAL_CORE_CONSOLE is not defined.

This patch works around the problem by checking for SUPPORT_SYSRQ _and_ CONFIG_SERIAL_CORE_CONSOLE before accessing the "sysrq" member of struct uart_port.

Signed-off-by: Helge Deller <deller@gmx.de>


diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 4e4f127..b9d79f1 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -446,7 +446,7 @@ int uart_resume_port(struct uart_driver *reg, struct uart_port *port);
 static inline int
 uart_handle_sysrq_char(struct uart_port *port, unsigned int ch)
 {
-#ifdef SUPPORT_SYSRQ
+#if defined(SUPPORT_SYSRQ) && defined(CONFIG_SERIAL_CORE_CONSOLE)
 	if (port->sysrq) {
 		if (ch && time_before(jiffies, port->sysrq)) {
 			handle_sysrq(ch, port->info ? port->info->port.tty : NULL);
@@ -458,9 +458,6 @@ uart_handle_sysrq_char(struct uart_port *port, unsigned int ch)
 #endif
 	return 0;
 }
-#ifndef SUPPORT_SYSRQ
-#define uart_handle_sysrq_char(port,ch) uart_handle_sysrq_char(port, 0)
-#endif
 
 /*
  * We do the SysRQ and SAK checking like this...
@@ -468,7 +465,7 @@ uart_handle_sysrq_char(struct uart_port *port, unsigned int ch)
 static inline int uart_handle_break(struct uart_port *port)
 {
 	struct uart_info *info = port->info;
-#ifdef SUPPORT_SYSRQ
+#if defined(SUPPORT_SYSRQ) && defined(CONFIG_SERIAL_CORE_CONSOLE)
 	if (port->cons && port->cons->index == port->line) {
 		if (!port->sysrq) {
 			port->sysrq = jiffies + HZ*5;
