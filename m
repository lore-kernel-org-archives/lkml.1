Return-Path: <linux-kernel-owner+w=401wt.eu-S1764019AbXF0XJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764019AbXF0XJx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 19:09:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763843AbXF0XJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 19:09:39 -0400
Received: from wx-out-0506.google.com ([66.249.82.233]:58742 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763943AbXF0XJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 19:09:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=rE7XI8R24rQ+LwIsJlMj9nEId7NgHgXbNe+N/tyqEvtMBd4fMk5AT54eqdlloyRf0ngrq8Wkt5CLDtikC/yeMQjCGEld4ndQTmMOu72v3DcBsYOI4JUurZ6pbECm7oyQ+o6Qgvs/CMLkUYqQsJswJYZkA2YNkijam/STqJZNCH8=
Message-ID: <6f703f960706271609m6fdfb9c1ha3555a68fe1d9d55@mail.gmail.com>
Date: Wed, 27 Jun 2007 15:09:37 -0800
From: "Kent Overstreet" <kent.overstreet@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: [RFC] LVM/RAID/FS integration
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I believe I have the right way of going about it. I agree with the
kernel developers who've stated that ZFS is a layering violation, and
we can do better.

 Consider a filesystem on a set of drives; it may want some data to be
in a raid5 and some to be mirrored. The correct interface for the
filesystem is to have two or more opaque volumes, which it may be able
to resize depending on usage.

Basically, the order we want is fs -> raid -> lvm. Given a set of
identical drives, we want LVM to handle them separately and divide
them up into LVs identically; then corresponding LVs are raided
together. We might have a raid5 volume and a raid1 volume, each of
which can be resized independently. The FS then makes use of both of
them, putting metadata and frequently used data on the raid1 and
everything else on the raid5 (btrfs, as I understand it, will be able
to do this sort of thing eventually).

The trouble is it's completely impractical with current tools; we need
tighter integration between md and LVM. Basically, we need a new type
of VG; you'd only be able to make it out of PVs that are the same size
(or close). Then, when you create an LV you decide what kind of
redundancy you want; the LVM internally creates multiple LVs and raids
them together to make the LV the fs sees.

This could, sort of, be done in userspace, but I think it'll work
better if dm and md are better integrated in the kernel. I thought i'd
throw out my ideas before I get too far in. Thoughts?
