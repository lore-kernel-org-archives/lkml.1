Return-Path: <linux-kernel-owner+w=401wt.eu-S1762700AbYHERC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762700AbYHERC3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 13:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758187AbYHERCV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 13:02:21 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:22888 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185AbYHERCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 13:02:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=dqasIZAPryQeVHXHeVFRVaxRHmPmnw6CHsZlLkZ5D483s8WrS7qfiW6wyOOtUmN0Qd
         4DXMC1s3foWUwzC3Ptp3ZsSFWoi1WCo6LkbFiu3cYHjBMxN2RsuExko9iZZijz/spw80
         06Nd6w65O5lDGNvxsAVZzOne/pHFP+V6eHG9k=
Message-ID: <3ae3aa420808051002n2438c0f6g82fb783b5102d149@mail.gmail.com>
Date: Tue, 5 Aug 2008 12:02:18 -0500
From: "Linas Vepstas" <linasvepstas@gmail.com>
Reply-To: linasvepstas@gmail.com
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: amd64 sata_nv (massive) memory corruption
Cc: "John Stoffel" <john@stoffel.org>,
       "Alistair John Strachan" <alistair@devzero.co.uk>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080803231628.1361b75f@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3ae3aa420808011030weadc61fvf6f850f0a4cfcb3e@mail.gmail.com>
	 <200808012319.05038.alistair@devzero.co.uk>
	 <3ae3aa420808011951l58da4010r1ff0876f255565b0@mail.gmail.com>
	 <18580.48861.657366.629904@stoffel.org>
	 <3ae3aa420808021501k2e871dc0y344dd7f9a7b80614@mail.gmail.com>
	 <18581.6873.353028.695909@stoffel.org>
	 <3ae3aa420808031523i1d9559d9i19dd5fcc9d5719c7@mail.gmail.com>
	 <20080803231628.1361b75f@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/8/3 Alan Cox <alan@lxorguk.ukuu.org.uk>:

>> -- The bad ram passes memtest86+
>
> You are assuming bad RAM then not bad bus loadings, corrosion on the
> pins.. ?

Yes, probably bad timing due to bus loading or bad impedance
due to bad connector, or whatever.

> If you have a good enough pile of hardware and the right monitoring stuff
> loaded then you should get EDAC event logs

I've got the AMD 570 chipset, which is older than the
amd76x that edac supports.  The latest MB's seem to have
the AMD 790 chipset, which is also not currently supported.

Can anyone get me the portion of the AMD 570 (nVidia
nForce 570) chip specs that describe the RAM ECC
error event counters? (I assume that this chip has some
sort of error reporting or counting registers) I can sign
NDA if needed.

> The more interesting approaches I think
> are the fs level ones where you accept the fact that hardware sucks and
> do end to end checksumming from the fs or even the app in some
> situations. We don't yet have that functionality mainstream although it
> might make an interesting device mapper module ...

I'm game. Care to guide me through?  So: on every write, this
new device mapper module computes a checksum and stores
it somewhere. On every read, it computes a checksum and
compares to the stored value. Easy enough I guess.

Several hard parts:
-- where to store the checksums?
-- what to do (besides print to dmesg) if there's a mismatch?
-- on an md raid-1, if there's a checksum error on one of the
   disks, then one could check the other disk to see if its good.
   This suggests a new API:

   ++ "is this block device an md device?"
   ++ "if yes to above, then give me alternate block"
   ++ "invalidate copy n of block x"
         (this last, because presumably one wants to tell md that
         one of its copies is bad.)

  (Actually, above API would be interesting for fsck too ..
   if fsck is failing with one copy from a raid set, it would
   be interesting to see if an alternate copy passes fsck.)

-- but perhaps the storage containing the checksums themselves
    was corrupted. Not sure what to do then. If the checksums
    are corrupted, I don't want to accidentally flag large portions
    of a block device being bad, when its actually good.

An alternative would be file-level checksums built into the
file system. I'm not thrilled by this, because it fails to focus
on errors caused by bad hardware. Its also too close to
trip-wire like function, and I don't want to get into conversations
about security & etc.

I'm paranoid enough to be willing to implement something like
this .. is the above design on the right track?

--linas
