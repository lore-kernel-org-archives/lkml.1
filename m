Return-Path: <linux-kernel-owner+w=401wt.eu-S1755708AbZJVNbL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708AbZJVNbL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 09:31:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755536AbZJVNbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 09:31:10 -0400
Received: from mail-px0-f179.google.com ([209.85.216.179]:49600 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755525AbZJVNbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 09:31:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=EyMJnEKSI0ZLNdSd/uxyKKhi7ggTLSphDYe6hMrxoNn279CScv+hCwI/cUExTSFqU9
         AwR8hPJv9k2RQ5GMok2zhzEsVQoyHrdj/uZiUyG8PjReNeNpifoK+t9xkBcNDvB8sVVw
         /tC6QBUUc0SXhpohWaNjz8dYbgMeKEUJko+Iw=
Subject: Re: [PATCH -v4 9/9] tracing: add function graph tracer support for
 MIPS
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: rostedt@goodmis.org
Cc: David Daney <ddaney@caviumnetworks.com>, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org, Thomas Gleixner <tglx@linutronix.de>,
       Ralf Baechle <ralf@linux-mips.org>,
       Nicholas Mc Guire <der.herr@hofr.at>
In-Reply-To: <1256217444.20866.599.camel@gandalf.stny.rr.com>
References: <028867b99ec532b84963a35e7d552becc783cafc.1256135456.git.wuzhangjin@gmail.com>
	 <2f73eae542c47ac5bbb9f7280e6c0271d193e90d.1256135456.git.wuzhangjin@gmail.com>
	 <3f0d3515f74a58f4cfd11e61b62a129fdc21e3a7.1256135456.git.wuzhangjin@gmail.com>
	 <ea8aa927fbd184b54941e4c2ae0be8ea0b4f6b8a.1256135456.git.wuzhangjin@gmail.com>
	 <96110ea5dd4d3d54eb97d0bb708a5bd81c7a50b5.1256135456.git.wuzhangjin@gmail.com>
	 <5dda13e8e3a9c9dba4bb7179183941bda502604f.1256135456.git.wuzhangjin@gmail.com>
	 <af3ec1b5cd06b6f6a461c9fa7d09a51fabccb08d.1256135456.git.wuzhangjin@gmail.com>
	 <a6f2959a69b6a77dd32cc36a5c8202f97d524f1e.1256135456.git.wuzhangjin@gmail.com>
	 <53bdfdd95ec4fa00d4cc505bb5972cf21243a14d.1256135456.git.wuzhangjin@gmail.com>
	 <1256141540.18347.3118.camel@gandalf.stny.rr.com>
	 <4ADF38D5.9060100@caviumnetworks.com>
	 <1256143568.18347.3169.camel@gandalf.stny.rr.com>
	 <4ADF3FE0.5090104@caviumnetworks.com>
	 <1256145813.18347.3210.camel@gandalf.stny.rr.com>
	 <1256211516.3852.47.camel@falcon>
	 <1256217444.20866.599.camel@gandalf.stny.rr.com>
Content-Type: text/plain
Organization: DSLab, Lanzhou University, China
Date: Thu, 22 Oct 2009 21:31:03 +0800
Message-Id: <1256218263.3852.115.camel@falcon>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-22 at 09:17 -0400, Steven Rostedt wrote:
> On Thu, 2009-10-22 at 19:38 +0800, Wu Zhangjin wrote:
> > Hi,
> > 
> > On Wed, 2009-10-21 at 13:23 -0400, Steven Rostedt wrote:
> 
> > Ralf have told me -pg really works with -fomit-frame-pointer, although
> > the gcc tool tell us they are not incompatible when we use both of them
> > together, but when I remove -fno-omit-frame-pointer in
> > KBUILD_FLAGS(enabled by CONFIG_FRAME_POINTER), it definitely remove the
> > s8(fp) relative source code(Seems -fomit-frame-pionter is used by
> > default by gcc), the leaf function becomes this:
> > 
> > function:
> > 
> > 80101144 <au1k_wait>:
> > 80101144:       03e00821        move    at,ra
> > 80101148:       0c04271c        jal     80109c70 <_mcount>
> >
> > No more instruction,
> > 
> > and the non-leaf function becomes,
> > 
> > 80126590 <copy_process>:
> > 80126590:       27bdffa0        addiu   sp,sp,-96
> > 80126594:       afbf005c        sw      ra,92(sp)
> > 80126598:       afbe0058        sw      s8,88(sp)
> > 8012659c:       afb70054        sw      s7,84(sp)
> > 801265a0:       afb60050        sw      s6,80(sp)
> > 801265a4:       afb5004c        sw      s5,76(sp)
> > 801265a8:       afb40048        sw      s4,72(sp)
> > 801265ac:       afb30044        sw      s3,68(sp)
> > 801265b0:       afb20040        sw      s2,64(sp)
> > 801265b4:       afb1003c        sw      s1,60(sp)
> > 801265b8:       afb00038        sw      s0,56(sp)
> > 801265bc:       03e00821        move    at,ra
> > 801265c0:       0c04271c        jal     80109c70 <_mcount>
> > 
> > It may save about two instructions for us.
> > 	
> > 	sw	s8, offset(sp)
> > 	move	s8, fp
> > 
> > and also, I have tried to just search "Save" instruction, if I find one,
> 
> So you look for "sw ..."?
> 
> > that should be a non-leaf function, otherwise, it's leaf function, but I
> > can not prove no "Save" instruction before the leaf function's "move at,
> > ra", for example:
> 
> Yes but it should never be saving the ra. You can search all
> instructions before the move at,ra until you find the save of the ra, or
> you find something that is not a save. If you find the saving of ra, it
> is not a leaf, but if you don't find the saving of ra, then it is a
> leaf.
> 
> > 
> > 8010113c:       03e00008        jr      ra
> > 80101140:       00020021        nop
> > 
> > 80101144 <au1k_wait>:
> > 80101144:       03e00821        move    at,ra
> > 80101148:       0c04271c        jal     80109c70 <_mcount>
> > 
> > if there is "save" instruction at address 80101140, it will fail.
> > Although, I met not failure with several tries, but no prove on it! any
> > ABI protection for this? if YES, this should be a better solution, for
> > it may works without -fno-omit-frame-pointer and save several
> > instructions for us.
> 
> If we don't stop at just one save, but look for the saving of ra, it
> should not fail.
> 

We can not look for the saving of ra continuously(when should we stop?
if with -fno-omit-fram-pointer, we have "move s8,sp" or "addiu sp, sp,
-offset", but without it, we have no "guideboard" to know that is the
beginning of the function!), 'Cause we may find the saving of ra of
another function, which will fail at that time.

BTW: Just replace probe_kernel_read() and tracing_stop/tracing_start by
asm, it works in 32bit, but fails in 64bit, I'm trying to find why!(TLB
miss on load or ifetch, will fix it asap! and resend the patchset out!)

Regards,
	Wu Zhangjin

