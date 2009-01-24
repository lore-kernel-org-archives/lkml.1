Return-Path: <linux-kernel-owner+w=401wt.eu-S1755636AbZAXJHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636AbZAXJHc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 04:07:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750976AbZAXJHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 04:07:13 -0500
Received: from rv-out-0506.google.com ([209.85.198.229]:55004 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbZAXJHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 04:07:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RB14+Bgv7qXbbpkTFXwKEYm/3O7i4LOOjNqZizJh9czw0YqDkNZjkpsZwfo1w2kHhN
         7Gmb5h8zGOiV+RmmCDL6tBz14/cC23MR8jonas6nfeT4DaTeGPdeONxjbCvhMpsG/YEl
         aIs4Vf5Tdx/mkV2MzfUtBiOxcs3yRRHFqaZ58=
MIME-Version: 1.0
In-Reply-To: <20090123134518.GA23513@sgi.com>
References: <4104961b0901220259u51677cbdkda2ed84dc2892543@mail.gmail.com>
	 <20090122133107.GA27592@sgi.com>
	 <4104961b0901222237h7fac5b1vf1b3b7f9d06d550c@mail.gmail.com>
	 <20090123134518.GA23513@sgi.com>
Date: Sat, 24 Jan 2009 17:07:07 +0800
Message-ID: <4104961b0901240107nb8e8579we66bd92fe11b62e8@mail.gmail.com>
Subject: Re: How to generate a Kerntypes file?
From: jidong xiao <jidong.xiao@gmail.com>
To: Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2009 at 9:45 PM, Cliff Wickman <cpw@sgi.com> wrote:
> On Fri, Jan 23, 2009 at 02:37:12PM +0800, jidong xiao wrote:
>> On Thu, Jan 22, 2009 at 9:31 PM, Cliff Wickman <cpw@sgi.com> wrote:
>> > Hi Jason,
>> >
>> > On Thu, Jan 22, 2009 at 06:59:34PM +0800, jidong xiao wrote:
>> >> Hi,All,
>> >>
>> >> Sometimes when I install a kernel I saw there is a Kerntypes file
>> >> installed under /boot directory, but sometimes no, I remember when I
>> >> install a sles9 kernel, there must be a Kerntypes file installed, but
>> >> most of other kernels doesn't include such a Kerntypes file. This file
>> >> is very useful for me to do some analysis, so I hope I can generate it
>> >> every time I build a kernel. Do I need a patch for this or there are
>> >> already some patches I can take use of?Thanks.
>> >
>> > You had a init/kerntypes.c in sles9 and sles10. It included a lot
>> > of basic kernel types.  It was compiled with -g to make the kerntypes.
>> > I presume that you used the LKCD project's lcrash with the kerntypes.
>> >
>> Hi, Cliff,
>>
>> Thanks for your guides.
>>
>> Well yes I am intending to use lcrash to load the kernel debug information.
>>
>> I noticed that recently kdb is going to be able to print out kernel
>> structures, and now I want to test that feature, I started my
>> experiments by reading the instructions inside
>> kdb/modules/kdbm_debugtypes.c which is saying:
>>
>>  * Usage:
>>  *  in order for the insmod kdbm_debugtypes.ko to succeed in loading types
>>  *  you must first use  lcrash -t kerntypes.xxxx -o debug_info
>>  *  and echo debug_info > /proc/kdb/debug_info_name
>>
>> so I have to generate kerntypes file. I looked into init/kerntypes.c,
>> it seems there is nothing but just includes some header files, like
>> below:
>>
>>      16 #include <linux/compile.h>
>>      17 #include <linux/module.h>
>>      18 #include <linux/mm.h>
>>      19 #include <linux/vmalloc.h>
>>      20 #include <linux/config.h>
>>      21 #include <linux/utsname.h>
>>      22 #include <linux/kernel_stat.h>
>>      23 #include <linux/dump.h>
>>      24
>>      25 #include <asm/kerntypes.h>
>>
>> We can see here are 9 files are included, does this mean the resulted
>> Kerntypes file only provides kernel structures that are defined within
>> these 9 files?
> Yes
>> If I want to print out more kernel structures I need to
>> change this file so as to include more header files?
>
> Yes, in theory. But not so easily done, as you can't throw in any and every
> header and get a clean compile.
>
>> In addition, if I want to generate Kerntypes file via building a
>> mainline kernel(rather than SLES kernel), the only thing I need to do
>> is:
>> 1. add this init/kerntypes.c and include/asm/kerntypes.h into kernel
>> source code.
>> 2. change the Makefile accordingly.
>>
>> After that I just compile the kernel as usual and I should be able to
>> get the Kerntypes file(which is actually nothing but just
>> init/kerntypes.o), right?
>
> You wouldn't use init/kerntypes.c
> In your .config file set CONFIG_DEBUG_INFO=y
> That will cause the whole kernel to be compiled with -g.
> Then:   dwarfextract -Pp vmlinux kerntypes
> You can append the structures from any modules:
>  dwarfextract kerntypes -c xxx.ko,yyy.ko,zzz.ko kerntypes.with.modules
>
Hmm,this is very cool, I usually enable the kernel debug options in
config file.
>>
>> Regards
>> Jason
>>
>> > If you download lkcd (lkcd.svn.sourceforge.net) you also build a
>> > tool called dwarfextract.  It is able to pull all the structure
>> > definitions out of a -g (CONFIG_DEBUG_INFO) kernel and any selected
>> > modules.  That is useful with the lcrash command.
> BTW  there are recent additions to dwarfextract. you might want to
>     re-download lkcd.
>
Okay, I see. I will try dwarfextract first and let you know if I meet
further issue. Thanks

Regards
Jason
> -Cliff
> --
> Cliff Wickman
> Silicon Graphics, Inc.
> cpw@sgi.com
> (651) 683-3824
>
