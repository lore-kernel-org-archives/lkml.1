Return-Path: <linux-kernel-owner+w=401wt.eu-S1751542AbZJWJct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751542AbZJWJct (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 05:32:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751334AbZJWJct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 05:32:49 -0400
Received: from mail-px0-f171.google.com ([209.85.216.171]:49011 "EHLO
	mail-px0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbZJWJcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 05:32:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=U+gr4qXRs3L3h4WhNVmkMMCiAtlmfl7Gy+JNfFcP2jVbX1Z7q963YTiQ6fxzQKXceH
         hRrzzzZVbKwjsr5Tuc/byWS5kH30mizUYZ7kjaiX3ItD5vpyYY+/a4Afe0qX8/tJ523B
         k3s4MQihUbelhI8+az9F6qXLvmZOPekIG37Z0=
Subject: Re: [PATCH -v4 4/9] tracing: add static function tracer support
 for MIPS
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Richard Sandiford <rdsandiford@googlemail.com>
Cc: David Daney <ddaney@caviumnetworks.com>,
       Adam Nemet <anemet@caviumnetworks.com>, rostedt@goodmis.org,
       linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Ralf Baechle <ralf@linux-mips.org>,
       Nicholas Mc Guire <der.herr@hofr.at>
In-Reply-To: <87y6n36plp.fsf@firetop.home>
References: <028867b99ec532b84963a35e7d552becc783cafc.1256135456.git.wuzhangjin@gmail.com>
	 <2f73eae542c47ac5bbb9f7280e6c0271d193e90d.1256135456.git.wuzhangjin@gmail.com>
	 <3f0d3515f74a58f4cfd11e61b62a129fdc21e3a7.1256135456.git.wuzhangjin@gmail.com>
	 <ea8aa927fbd184b54941e4c2ae0be8ea0b4f6b8a.1256135456.git.wuzhangjin@gmail.com>
	 <1256138686.18347.3039.camel@gandalf.stny.rr.com>
	 <1256233679.23653.7.camel@falcon> <4AE0A5BE.8000601@caviumnetworks.com>
	 <87y6n36plp.fsf@firetop.home>
Content-Type: text/plain
Organization: DSLab, Lanzhou University, China
Date: Fri, 23 Oct 2009 17:32:40 +0800
Message-Id: <1256290360.6381.51.camel@falcon>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 2009-10-22 at 23:17 +0100, Richard Sandiford wrote:
> David Daney <ddaney@caviumnetworks.com> writes:
[...]
> > and here:
> >
> > http://www.linux-mips.org/archives/linux-mips/2009-10/msg00290.html
> 
> I'm not sure that the "search for a save of RA" thing is really a good idea.
> The last version of that seemed to be "assume that any register stores
> will be in a block that immediately precedes the move into RA", but even
> if that's true now, it might not be in future.  And as Wu Zhangjin says,
> it doesn't cope with long calls, where the target address is loaded
> into a temporary register before the call.
> 

-mlong-calls works with the current implementation of static function
tracer and function graph tracer for MIPS, just tried them, and module
support is supported by default with -mlong-calls, let's have a look at
the dumped code with -mlong-calls, only a few difference.

ffffffff80241520 <copy_process>:
ffffffff80241520:       67bdff40        daddiu  sp,sp,-192
ffffffff80241524:       ffbe00b0        sd      s8,176(sp)
ffffffff80241528:       03a0f02d        move    s8,sp
ffffffff8024152c:       ffbf00b8        sd      ra,184(sp)
ffffffff80241530:       ffb700a8        sd      s7,168(sp)
ffffffff80241534:       ffb600a0        sd      s6,160(sp)
ffffffff80241538:       ffb50098        sd      s5,152(sp)
ffffffff8024153c:       ffb40090        sd      s4,144(sp)
ffffffff80241540:       ffb30088        sd      s3,136(sp)
ffffffff80241544:       ffb20080        sd      s2,128(sp)
ffffffff80241548:       ffb10078        sd      s1,120(sp)
ffffffff8024154c:       ffb00070        sd      s0,112(sp)
ffffffff80241550:       3c038021        lui     v1,0x8021
ffffffff80241554:       64631750        daddiu  v1,v1,5968
ffffffff80241558:       03e0082d        move    at,ra
ffffffff8024155c:       0060f809        jalr    v1

so, the only left job is making dynamic function tracer work with
-mlong-calls, I think it's not that complex, after using -mlong-calls,
we need to search "move at,ra; jalr v1" instead of "jal _mcount", and
also, some relative job need to do. will try to make it work next week.

> FWIW, I'd certainly be happy to make GCC pass an additional parameter
> to _mcount.  The parameter could give the address of the return slot,
> or null for leaf functions.  In almost all cases[*], there would be
> no overhead, since the move would go in the delay slot of the call.
> 
> [*] Meaning when the frame is <=32k. ;)  I'm guessing you never
>     get anywhere near that, and if you did, the scan thing wouldn't
>     work anyway.
> 
> The new behaviour could be controlled by a command-line option,
> which would also give linux a cheap way of checking whether the
> feature is available.

I like your suggestion, and I have tried to make gcc do something like
this before your reply.

orig:

move    at,ra
jal	_mcount

new:

sd      ra,184(sp)
...
move	at, ra
jal	_mcount
lui	ra, 184			--> This is new

so, in a non-leaf function, the at register stored the stack offset of
the return address(range from 0 to PT_SIZE). in a leaf function, it is
the return address itself(at least bigger than PT_SIZE). we are easier
to distinguish them. and only a few lines of source code need to be
added for gcc.

Regards,
	Wu Zhangjin

