Return-Path: <linux-kernel-owner+w=401wt.eu-S1755190AbXGIMrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190AbXGIMrf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 08:47:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbXGIMr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 08:47:27 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:14880 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106AbXGIMr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 08:47:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=XEESQOTrNPaMUJ+sSljMcjMDle16kxRIcjls1uERWAbqi/hpvv6A/rO8v9eoA4wxsuHpgIBR8wGZFInRMHyG97ftYmBeGG1uiaocZpbCkG/VDWr1TD1ZWbiVb2SwpjgsBwe2GtmDa6m+g1jQ7nVnCmkF1fmEHwff6gL66Bx3gFU=
Message-ID: <84144f020707090547p5ccb1ec7i5197c8312c910551@mail.gmail.com>
Date: Mon, 9 Jul 2007 15:47:25 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Nick Piggin" <nickpiggin@yahoo.com.au>
Subject: Re: [patch 09/10] Remove the SLOB allocator for 2.6.23
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Christoph Lameter" <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linux-mm@vger.kernel.org, suresh.b.siddha@intel.com,
       corey.d.gough@intel.com, "Matt Mackall" <mpm@selenic.com>,
       "Denis Vlasenko" <vda.linux@googlemail.com>,
       "Erik Andersen" <andersen@codepoet.org>
In-Reply-To: <46921928.8020900@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070708034952.022985379@sgi.com>
	 <20070708035018.074510057@sgi.com> <20070708075119.GA16631@elte.hu>
	 <20070708110224.9cd9df5b.akpm@linux-foundation.org>
	 <4691A415.6040208@yahoo.com.au>
	 <84144f020707090404l657a62c7x89d7d06b3dd6c34b@mail.gmail.com>
	 <46921928.8020900@yahoo.com.au>
X-Google-Sender-Auth: 9983043e4f986b8b
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,

Pekka Enberg wrote:
> > I assume with "slab external fragmentation" you mean allocating a
> > whole page for a slab when there are not enough objects to fill the
> > whole thing thus wasting memory?

On 7/9/07, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> Yep. Without really analysing it, I guess SLOB's savings here are
> O(1) over SLUB and will relatively diminish as the machine size gets
> larger, however with the number of slabs even a small kernel creates,
> this is likely to be significant on small memory systems.

Running the included script on my little Debian on UML with 32 MB of
RAM shows anywhere from 20 KB up to 100 KB of wasted space on light
load. What's interesting is that the wasted amount seems to stabilize
around 70 KB and never goes below that.

                                               Pekka

#!/bin/bash

total_wasted=0

for i in $(find /sys/slab -type d -mindepth 1 -maxdepth 1 | sort)
do
  nr_objs=$(cat $i/objects)
  slabs=$(cat $i/slabs)
  objs_per_slab=$(cat $i/objs_per_slab)
  let "max_objs=$objs_per_slab*$slabs"

  object_size=$(cat $i/object_size)
  let "wasted=($max_objs-$nr_objs)*$object_size"

  if [ "$wasted" -ne "0" ]; then
    echo "$i: max_objs=$max_objs, nr_objs=$nr_objs, $wasted bytes wasted"
  fi
  let "total_wasted=$total_wasted+$wasted"
done

echo "Total wasted: $total_wasted"
