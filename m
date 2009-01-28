Return-Path: <linux-kernel-owner+w=401wt.eu-S1756553AbZA1WTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553AbZA1WTR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 17:19:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751656AbZA1WTD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 17:19:03 -0500
Received: from mx2.redhat.com ([66.187.237.31]:42483 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049AbZA1WTA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 17:19:00 -0500
From: Jarod Wilson <jarod@redhat.com>
Organization: Red Hat, Inc.
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH RFT 7/7] firewire: sbp2: add workarounds for 2nd and 3rd generation iPods
Date: Wed, 28 Jan 2009 17:18:41 -0500
User-Agent: KMail/1.10.4 (Linux/2.6.27.12-170.2.5.fc10.x86_64; KDE/4.1.4; x86_64; ; )
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Kristian =?iso-8859-1?q?H=F8gsberg?= <krh@bitplanet.net>
References: <tkrat.6fe4fe5b72231863@s5r6.in-berlin.de> <tkrat.b82b9fbc17b1a032@s5r6.in-berlin.de>
In-Reply-To: <tkrat.b82b9fbc17b1a032@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200901281718.41873.jarod@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 24 January 2009 13:46:44 Stefan Richter wrote:
> According to https://bugs.launchpad.net/bugs/294391
>   - 3rd generation iPods need the "fix capacity" workaround after all
>     (apparently they crash after the last sector was accessed),

I've got a 3rd-gen iPod contributed to the testing stash here, but its...
Well, quirky. Was originally a 40G that someone put a 60G drive into,
and it fails to function when hooked to both a Linux box and a Mac OS X
box via FireWire, but works w/both when hooked up via USB...

In other words, its pretty much worthless for FireWire testing.

>   - 2nd generation iPods need the "128 kB maximum request size"
>     workaround.

I do have a functional 2nd-gen (its Kristian's actually). From what I've
seen so far, it does work just fine w/only the 128k max req workaround
set.

> Furthermore, Kristian Høgsberg mentioned that 2nd generation iPods
> treat page tables (scatter-gather lists) as data buffers, i.e. ignore
> the page_table_present bit of command block ORBs.  If this is true, then
> the 128 kB limit is not a sufficient workaround; instead we have to
> guarantee that all requests have only a single s/g element.  This could
> be up to 64 kByte - 4 Bytes in size.  But I expect the block layer to
> typically emit much smaller elements than that, alas.

So far, the 128k bit does in practice seem to be sufficient. Of course,
I haven't done anything like run iozone against this, let alone tried
shoving a bunch of music onto it...

> Alas both iPod generations feature the same model ID in the config ROM,
> hence we can only define a shared quirks list entry for them.  This is
> bad since
>   - the "fix capacity" workaround prevents access to the very last
>     sector if a device does not actually have this bug,
>   - the "no page tables" workaround dramatically reduces throughput,
>     e.g. from 25 to 9 MB/s without gap count optimization, and from 36
>     11 MB/s with gap count optimization (as per hdparm with a regular
>     3.5" S400 disk on an i686 PC without IOMMU).  Whether this matters
>     with the already slow iPod disk is not yet known.

I was able to dd the entire 2nd-gen ipod at 12.5MB/s when using just the
128k workaround (i.e. workarounds=0x101).

# dd if=/dev/sdc of=/dev/null
19531260+0 records in
19531260+0 records out
10000005120 bytes (10 GB) copied, 798.382 s, 12.5 MB/s

> This patch needs testing by somebody who has the hardware:
>   - Do 2nd and 3rd gen. iPods actually have a model_id == 0, or do they
>     have in fact no model_id at all?

So far as I can decipher (using Kristian's csr-dump utility), they really
do have model_id == 0.

Would it make any sense to try keying off any additional values in the
config rom to better restrict where workarounds are applied?

Of course, there's not much to go on... The only things I can see different
between the 2nd and 3rd gen ones here are the bib header, the guid
(obviously), the unit directory length and crc and the management orb
timeout value. If the orb timeout values are consistent across the same
model, that might be the best shot...

>   - Does the "fix capacity" workaround harm usage of 2nd gen. iPods?

Doesn't affect dd'ing the disk, doubtful it'd affect actual usage, unless 
someone had a completely filled iPod (workarounds=0x109).

# dd if=/dev/sdc of=/dev/null
19531259+0 records in
19531259+0 records out
10000004608 bytes (10 GB) copied, 811.963 s, 12.3 MB/s

>   - Is the "no page tables" workaround really necessary for 2nd gen.
>     iPods, or is the 128k limit sufficient as reported for the Ubuntu
>     8.10 kernel?

Looks to me like the no page tables workaround isn't needed. I could
have sworn the defaults w/this patch (workarounds 0x48) was actually
causing dd to fail last night, but I haven't been able to reproduce
that failure, now that I'm trying (maybe I this ipod mixed up with one
of the others in the pile...). It certainly does slaughter performance
though. I halted this dd after getting tired of waiting:

# dd if=/dev/sdc of=/dev/null
^C1139425+0 records in
1139424+0 records out
583385088 bytes (583 MB) copied, 1220.87 s, 478 kB/s

Yeah, lets not do the no page tables workaround. :)

>   - How badly does the "no page tables" workaround affect throughput of
>     3rd gen. iPods which don't need it?

Can't tell, since this one doesn't behave via FireWire. Wonder if it
would behave better if I transplanted the 40G drive from a 4th-gen into
it... Where's my sledge hammer?...

-- 
Jarod Wilson
jarod@redhat.com

