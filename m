Return-Path: <linux-kernel-owner+w=401wt.eu-S1760180AbYBVSoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760180AbYBVSoV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 13:44:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754764AbYBVSoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 13:44:14 -0500
Received: from fk-out-0910.google.com ([209.85.128.187]:12157 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754323AbYBVSoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 13:44:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=p2GfPW6Yss8+KNIqqhSz9SrHH+IujU4SGSSbWID6huYVh3X2XDkTbBEDu5RyuWgDDa6MJHgshYj4GT8k+MrOw0SNKKbrygAeYyL9xBD+m9Z6J6sHLSEtkuaFwVJ0AHGsW908UORter0V2IScj7Na6ZygkEPuWlObNE4ROqkfM3Q=
Message-ID: <47BF17F5.4040605@gmail.com>
Date: Fri, 22 Feb 2008 19:44:05 +0100
From: Vegard Nossum <vegard.nossum@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: don't save unreliable stack trace entries
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I find the following patch to make saved stack traces so much easier to
decipher. There might be other uses of save_stack_trace() that I am not
aware of, though. Also, I suggest changing the underlying struct
stack_trace to include the reliable/unreliable information. This, however,
requires all users of save_stack_trace() and all arches saving this
information to change.

Kind regards,
Vegard Nossum


 From 5edfd896c5f0d728111df3d8cae729a375f29d3c Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Fri, 22 Feb 2008 19:23:58 +0100
Subject: [PATCH] x86: don't save unreliable stack trace entries

Currently, there is no way for print_stack_trace() to determine whether a
given stack trace entry was deemed reliable or not, simply because
save_stack_trace() does not record this information. (Perhaps needless to
say, this makes the saved stack traces A LOT harder to read, and probably
with no other benefits, since debugging features that use
save_stack_trace() most likely also require frame pointers, etc.)

This patch reverts to the old behaviour of only recording the reliable trace
entries for saved stack traces.

Signed-off-by: Vegard Nossum <vegardno@ifi.uio.no>
---
  arch/x86/kernel/stacktrace.c |    4 ++++
  1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/stacktrace.c b/arch/x86/kernel/stacktrace.c
index 02f0f61..c28c342 100644
--- a/arch/x86/kernel/stacktrace.c
+++ b/arch/x86/kernel/stacktrace.c
@@ -25,6 +25,8 @@ static int save_stack_stack(void *data, char *name)
  static void save_stack_address(void *data, unsigned long addr, int reliable)
  {
  	struct stack_trace *trace = data;
+	if (!reliable)
+		return;
  	if (trace->skip > 0) {
  		trace->skip--;
  		return;
@@ -37,6 +39,8 @@ static void
  save_stack_address_nosched(void *data, unsigned long addr, int reliable)
  {
  	struct stack_trace *trace = (struct stack_trace *)data;
+	if (!reliable)
+		return;
  	if (in_sched_functions(addr))
  		return;
  	if (trace->skip > 0) {
-- 
1.5.3.8


