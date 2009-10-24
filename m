Return-Path: <linux-kernel-owner+w=401wt.eu-S1751920AbZJXPyK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920AbZJXPyK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Oct 2009 11:54:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751764AbZJXPyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Oct 2009 11:54:09 -0400
Received: from mail-px0-f179.google.com ([209.85.216.179]:41698 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727AbZJXPyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Oct 2009 11:54:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=dtAaqaeuOF60FhFDJIarXRlmBQWE/HzYtSyupcHuSAYp19fvteujctTHv82IW23Y6Q
         AIySyOT5QceQBMVaphOq+jv25oN3C5alkl3Gk7RzfQCFLS3NqL7JbhD98QWL2qlL0j6e
         Wski5lqYhsnduxi91wxjdRcnU6DiWtvpl/E44=
Subject: Re: [PATCH] MIPS: Add option to pass return address location to
 _mcount. Was: [PATCH -v4 4/9] tracing: add static function tracer support
 for MIPS
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Richard Sandiford <rdsandiford@googlemail.com>
Cc: David Daney <ddaney@caviumnetworks.com>,
       GCC Patches <gcc-patches@gcc.gnu.org>,
       Adam Nemet <anemet@caviumnetworks.com>, rostedt@goodmis.org,
       linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Ralf Baechle <ralf@linux-mips.org>,
       Nicholas Mc Guire <der.herr@hofr.at>
In-Reply-To: <87my3htau1.fsf@firetop.home>
References: <028867b99ec532b84963a35e7d552becc783cafc.1256135456.git.wuzhangjin@gmail.com>
	 <2f73eae542c47ac5bbb9f7280e6c0271d193e90d.1256135456.git.wuzhangjin@gmail.com>
	 <3f0d3515f74a58f4cfd11e61b62a129fdc21e3a7.1256135456.git.wuzhangjin@gmail.com>
	 <ea8aa927fbd184b54941e4c2ae0be8ea0b4f6b8a.1256135456.git.wuzhangjin@gmail.com>
	 <1256138686.18347.3039.camel@gandalf.stny.rr.com>
	 <1256233679.23653.7.camel@falcon> <4AE0A5BE.8000601@caviumnetworks.com>
	 <87y6n36plp.fsf@firetop.home> <4AE232AD.4050308@caviumnetworks.com>
	 <87my3htau1.fsf@firetop.home>
Content-Type: text/plain
Organization: DSLab, Lanzhou University, China
Date: Sat, 24 Oct 2009 23:53:52 +0800
Message-Id: <1256399632.24957.75.camel@falcon>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, 2009-10-24 at 10:12 +0100, Richard Sandiford wrote:
> Thanks for the patch.
[...]
> > How about this patch, I think it does what you suggest.
> >
> > When we pass -pg -mmcount-raloc, the address of the return address 
> > relative to sp is passed in $12 to _mcount.  If the return address is 
> > not saved, $12 will be zero.  I think this will work as registers are 
> > never saved with an offset of zero.  $12 is a temporary register that is 
> > not part of the ABI.
> 
> Hmm, well, the suggestion was to pass a pointer rather than an offset,
> but both you and Wu Zhangjin seem to prefer the offset.  Is there a
> reason for that?  I suggested a pointer because
> 
>   (a) they're more C-like
>   (b) they're just as quick and easy to compute
>   (c) MIPS doesn't have indexed addresses (well, except for a few
>       special cases) so the callee is going to have to compute the
>       pointer at some stage anyway
> 

Agree with you.

if not with -fno-omit-frame-pointer, we also need to calculate the frame
pointer, and then plus it with the offset. with pointer, we can get it
directly, but it may need a more instruction(lui..., addiu...) for
loading the pointer. of course, at last, the pointer will save more time
for us :-)

so, David, could you please use pointer instead? and then I will test it
asap(cloning the latest gcc currently). thanks!

> (It sounds from Wu Zhangjin's reply like he'd alread suggested the
> offset thing before I sent my message.  If so, sorry for not using
> that earlier message as context.)
> 

It doesn't matter, Seems at that time, you were not added in the CC
list, but added by David Daney later.

> > +  if (TARGET_RALOC)
> > +    {
> > +      /* If TARGET_RALOC load $12 with the offset of the ra save
> > +	 location.  */
> > +      if (mips_raloc_in_delay_slot_p())
> > +	emit_small_ra_offset = 1;
> > +      else
> > +	{
> > +	  if (Pmode == DImode)
> > +	    fprintf (file, "\tdli\t%s,%d\t\t# offset of ra\n", reg_names[12],
> > +		     cfun->machine->frame.ra_fp_offset);
> > +	  else
> > +	    fprintf (file, "\tli\t%s,%d\t\t# offset of ra\n", reg_names[12],
> > +		     cfun->machine->frame.ra_fp_offset);
> > +	}
> > +    }
> 
> We shouldn't need to do the delay slot dance.  With either the pointer
> ((D)LA) or offset ((D)LI) approach, the macro won't use $at, so we can
> insert the new code immediately before the jump, leaving the assembler
> to fill the delay slot.  This is simpler and should mean that the delay
> slot gets filled more often in the multi-insn-macro cases.
> 
> Looks good otherwise, but I'd be interested in other suggestions for
> the option name.  I kept misreading "raloc" as a typo for "reloc".
> 

The same misreading to me, what about -mmcount-ra-loc? add one "-", or
-mcount-ra-location?

BTW: Just made dynamic function tracer for MIPS support module tracing
with the help of -mlong-calls. after some more tests, I will send it as
-v5 revision later. hope the -v6 revision work with this new feature of
gcc from David Daney.

Regards,
	Wu Zhangjin

