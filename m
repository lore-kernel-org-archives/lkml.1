Return-Path: <linux-kernel-owner+w=401wt.eu-S1757318AbZDURnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318AbZDURnc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 13:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756752AbZDURm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 13:42:59 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:41837 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756272AbZDURm6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 13:42:58 -0400
Date: Tue, 21 Apr 2009 13:40:50 -0400 (EDT)
From: Anders Kaseorg <andersk@MIT.EDU>
To: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
cc: Tim Abbott <tabbott@MIT.EDU>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Jeff Arnold <jbarnold@MIT.EDU>
Subject: Re: [PATCH v2 0/4] Add support for compiling with	-ffunction-sections
 -fdata-sections
In-Reply-To: <20090421140228.GC3303@hack>
Message-ID: <alpine.DEB.2.00.0904211311110.7725@vinegar-pot.mit.edu>
References: <1238973278-31735-1-git-send-email-tabbott@mit.edu> <20090421140228.GC3303@hack>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Apr 2009, Américo Wang wrote:
> Nice work! But, don't -ffunction-sections and -fdata-sections have
> collisions with '-g' and 'gprof'? Just like what gcc(1) describes.

That description seems to be long obsolete.  gcc used to warn that 
-ffunction-sections may affect debugging, but that warning was disabled 
for ELF targets in 1999, presumably because ELF has always supported 
arbitrary section names even though some other object formats have issues.
  <http://gcc.gnu.org/ml/gcc-patches/2008-03/msg00975.html>

I know that debugging under -ffunction-sections -g works fine on at least 
x86, which is the only platform on which we currently propose to provide 
this option, and based on that message it looks like other platforms are 
fine too.

> IIRIC, another project of linux kernel is trying to 'gprof' the kernel 
> too.

gprof requires compiling with -pg, and yes, there is a conflict with 
-ffunction-sections -pg, as documented in the config help text.
  <http://lkml.org/lkml/2009/2/4/487>

That is why CONFIG_FUNCTION_DATA_SECTIONS already depends on 
!CONFIG_FUNCTION_TRACER.  Any external project that tries to add -pg to an 
-ffunction-sections kernel will get this warning from gcc:
  warning: -ffunction-sections disabled; it makes profiling impossible
which makes the situation clear.

This conflict appears to be bogus, and we have had no trouble with 
-ffunction-sections -pg after patching the conflict out of the gcc source.  
So we may eventually be able to remove it.
  <http://gcc.gnu.org/ml/gcc-help/2008-11/msg00128.html>

Anders
