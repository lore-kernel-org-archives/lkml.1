Return-Path: <linux-kernel-owner+w=401wt.eu-S1755121AbYKPVkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121AbYKPVkJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 16:40:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753140AbYKPVj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 16:39:58 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:43879 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842AbYKPVj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 16:39:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=hN1lwxh0+lKCy35yUn1ilXqVRun5RpKQC76/GkJjowl1sE3dgqkNds/s/3aKP3Hjzk
         14+1sN+6IjuDfr8HSKu4/KUvIibt2axB0PNmxjEh8Qe0iabnMZ3eVcKIccdx27r7QmZK
         zgyxpGYgTTpWb8CtztKcknhpMHQlEMAg+iwGc=
Message-ID: <21d7e9970811161339x174d6041x1622d478f8e4247e@mail.gmail.com>
Date: Mon, 17 Nov 2008 07:39:55 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: [PATCH 1/7] mm: introduce simple_malloc()/simple_free()
Cc: "David Miller" <davem@davemloft.net>, laijs@cn.fujitsu.com,
       akpm@linux-foundation.org, menage@google.com,
       kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com,
       jens.axboe@oracle.com, jack@suse.cz, jes@sgi.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081116105725.12458b13@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <491FA28B.2070003@cn.fujitsu.com>
	 <20081115205229.765f7ee3@infradead.org>
	 <20081116.001926.150424480.davem@davemloft.net>
	 <20081116105725.12458b13@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2008 at 4:57 AM, Arjan van de Ven <arjan@infradead.org> wrote:
> On Sun, 16 Nov 2008 00:19:26 -0800 (PST)
> David Miller <davem@davemloft.net> wrote:
>
>> From: Arjan van de Ven <arjan@infradead.org>
>> Date: Sat, 15 Nov 2008 20:52:29 -0800
>>
>> > On Sun, 16 Nov 2008 12:33:15 +0800
>> > Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
>> >
>> > >
>> > > some subsystem needs vmalloc() when required memory is large.
>> > > but current kernel has not APIs for this requirement.
>> > > this patch introduces simple_malloc() and simple_free().
>> >
>> > I kinda really don't like this approach. vmalloc() (and especially,
>> > vfree()) is a really expensive operation, and vmalloc()'d memory is
>> > also slower (due to tlb pressure). Realistically, people should try
>> > hard to use small datastructure instead....
>>
>> This is happening in many places, already, for good reason.
>>
>> There are lots of places where we can't (core hash tables, etc.)  and
>> we want NUMA spreading and reliable allocation, and thus vmalloc it
>> is.
>
> vmalloc() isn't 100% evil; for truely long term stuff it's sometimes a
> quite reasonable solution.
>
> There are some issues with it still: the vmalloc() space is shared
> with ioremap, modules and others and it's not all that big on 32 bit; on
> x86 you could well end up with only 64Mb total (after taking out the
> various ioremap's etc).
>
> Yes there's places where it's then totally fine to dip into this space
> at boot/init time. You mention a few very good users.
> (There's still the tlb miss cost on use but on modern cpus a tlb miss
> is actually quite cheap)
>
> But this doesn't make vmalloc() the magic bullet that solves the "oh
> Linux can't allocate large chunks of memory" problem. Specifically in
> driver space for things that get ported from other OSes.

So we keep the duplicated code? or we just audit new callers.... I
think this patch
makes it easier to spot new callers doing something stupid. As davem
said we duplicate
this code all over the place, so for that reason along a simple
wrapper makes things a lot
easier, and also possibly a lot easier to change in the future to a
new non-sucky API.

So I'm all for it maybe with a non simple name.

Dave.

>
> --
> Arjan van de Ven        Intel Open Source Technology Centre
> For development, discussion and tips for power savings,
> visit http://www.lesswatts.org
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
