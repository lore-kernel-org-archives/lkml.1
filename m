Return-Path: <linux-kernel-owner+w=401wt.eu-S1756000AbZCSKP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000AbZCSKP4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 06:15:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751530AbZCSKPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 06:15:47 -0400
Received: from relay.gothnet.se ([82.193.160.251]:65289 "EHLO
	GOTHNET-SMTP2.gothnet.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750934AbZCSKPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 06:15:46 -0400
Message-ID: <49C21B0B.4060809@shipmail.org>
Date: Thu, 19 Mar 2009 11:14:35 +0100
From: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@shipmail.org>
Organization: VMware
User-Agent: Thunderbird 1.5.0.7 (X11/20060921)
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: Greg KH <greg@kroah.com>, David Airlie <airlied@linux.ie>,
       Thomas Hellstrom <thellstrom@vmware.com>,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Richard Purdie <rpurdie@linux.intel.com>
Subject: Re: [patch 0/5] Intel Poulsbo/Morrestown DRM driver and DRM core
 	changes
References: <20090319040809.GA29249@kroah.com> <21d7e9970903182348v57a78188ocefe138d353ee197@mail.gmail.com>
In-Reply-To: <21d7e9970903182348v57a78188ocefe138d353ee197@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-BitDefender-Scanner: Mail not scanned due to license constraints
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave and Greg,

Some quick comments below.

Dave Airlie wrote:
> On Thu, Mar 19, 2009 at 2:08 PM, Greg KH <greg@kroah.com> wrote:
>   
>> Hi,
>>
>> Here's 5 patches that add the Intel Poulsbo/Morrestown DRM driver to the
>> kernel tree.
>>
>> There are 4 patches that make changes to the DRM core, and one patch
>> that adds the DRM driver itself.  The driver is added to the
>> drivers/staging/ directory because it is not the "final" driver that
>> Intel wishes to support over time.  The userspace api is going to
>> change, and work is currently underway to hook up properly with the
>> memory management system.
>>     
>
>   
>> However this work is going to take a while, and in the meantime, users
>> want to run Linux on this kind of hardware.  I'd really like to add the
>> driver to the staging tree, but it needs these core DRM changes in order
>> to get it to work properly.
>>
>> Originally I had a patch that basically duplicated the existing DRM
>> core, and embedded it with these changes and the PSB driver together
>> into one big mess of a kernel module.  But Richard convinced me that
>> this wasn't the "nicest" thing to do, and he did work on the PSB code
>> and dug out these older DRM patches.
>>
>> The only thing that looks a bit "odd" to me is the unlocked ioctl patch,
>> Thomas, is that thing really correct?
>>
>> David, I'd be glad to take the DRM changes through the staging tree, but
>> only if you ack them.
>>     
>
> First off, the non-staging patches need more complete changelog entries,
> a bit of meaning goes a long way. I'll ack them if they are documented and
> make sense. The unlocked ioctl hook makes sense to me at least!
>   

For the non-staging patches, (which also sit in the modesetting-newttm 
tree),
I can add some more elaborate comments. However I think all of them are 
targeted to support functionality for TTM, so unless the TTM code goes 
into staging or mainstream, there is little point in merging them to 
core drm before other drivers find them useful.

Although I see the patch adding TTM is including some backwards 
compatibility defines
(In particular the PAT compat stuff) that needs to be stripped.


> Now the non-core DRM driver comes with some caveats no one mentioned,
> only the userspace 2D is open, no userspace 3D is available and I've no idea if
> one is forthcoming. Now I don't know enough about the Poulsbo to say this
> drm implementation is secure and can't DMA over my password file.
>
>   

The GPU in Poulsbo / Morestown can only access memory through a 
multi-context 4GB two-level page-table, and the implementation of that 
is open in psb_mmu.c.
The VDC is accessing memory through a traditional Intel GTT: psb_gtt.c
The registers used to set up the page table are blocked from user-space 
access. Any registers used to fire GPU assembly code with privileges to 
change those registers are also blocked.

So security-wise there is nothing worse with this device than with other 
devices without full open documentation. And AFAICT it's more secure 
than some drivers _with_ full open documentation.
The non-existence of an open-source 3D implementation doesn't really 
alter that situation.

However, if there's a policy issue about adding Linux kernel support for 
closed-source user-space drivers, I think it helps to be explicit about 
that.


> There is no upstream X.org driver available for this yet, Ubuntu
> shipped something
> but really we should be at least seeing X.org and Mesa commitments from Intel
> to supporting this code in the future before we go shipping it all in
> the kernel.
>
>   

...

> Staging something with a very broken userspace API is going to be an nightmare,
> its fine if my audio doesn't work, but when X fails to start people
> are left in a lot worse
> place, personally I would never stage any driver that can break the
> users userspace
> this badly when we finally do get a version we want to upstream
> properly. GPU drivers
> are not just a kernel bit, they are not like a network card or sound
> driver, where the
> userspace API is mostly defined or a filesystem where we have POSIX.
>
>   

I can't really comment on this since I have no knowledge about the
upcoming interface changes.

Thanks,
Thomas

> So really I'm NAKing this from ever entering the mainline in its
> current form, without
> a supporting roadmap and plans for the userspace bits.
>
> Dave.
>
>   
>> thanks,
>>
>> greg k-h
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>>     
>
> ------------------------------------------------------------------------------
> Apps built with the Adobe(R) Flex(R) framework and Flex Builder(TM) are
> powering Web 2.0 with engaging, cross-platform capabilities. Quickly and
> easily build your RIAs with Flex Builder, the Eclipse(TM)based development
> software that enables intelligent coding and step-through debugging.
> Download the free 60 day trial. http://p.sf.net/sfu/www-adobe-com
> --
> _______________________________________________
> Dri-devel mailing list
> Dri-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/dri-devel
>   



