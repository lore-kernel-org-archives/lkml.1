Return-Path: <linux-kernel-owner+w=401wt.eu-S1755989AbZFKN1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989AbZFKN1F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 09:27:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751404AbZFKN0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 09:26:53 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:32940 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbZFKN0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 09:26:53 -0400
MIME-Version: 1.0
In-Reply-To: <1244723089-1145-1-git-send-email-ext-denis.2.karpov@nokia.com>
References: <1244723089-1145-1-git-send-email-ext-denis.2.karpov@nokia.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 11 Jun 2009 15:26:39 +0200
Message-ID: <ac3eb2510906110626i165aadf0ma57f320e7e8a2356@mail.gmail.com>
Subject: Re: [PATCH 0/5][V2] FS: userspace notification of errors
To: Denis Karpov <ext-denis.2.karpov@nokia.com>
Cc: hirofumi@mail.parknet.co.jp, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, adrian.hunter@nokia.com,
       artem.bityutskiy@nokia.com, akpm@linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 14:24, Denis Karpov<ext-denis.2.karpov@nokia.com> wrote:

> There were several objections to uevent usage, mostly with argument that
> uevents are meant to be used within a device context. One might argue that
> uevents are tied to kobjects that are not only used to represent devices,
> but also for other things (/sys/modules, /sys/fs, /sys/firmware).

No, the objection was to use the underlying *device* as the source to
raise filesystem events. I don't think there are problems in general
with objects in /sys/fs/ sending events.

But, the remaining questions here are:
Do we really want superblocks exported in the global,
non-namespace-aware /sys? It might be wrong to export stuff from other
namespaces for filesytems which are irrelevant, and not even visible.
I'm not sure about this, and it needs careful evaluation. We once had
filesystem mount/umount uevents on block devices, and we needed to
remove them for that namespace reason.

If we go that road, do we want all filesystems export their
superblocks here, like e.g. /sys/fs/super/<maj>:<min>/, or is this
custom fs-specific, like this patch does.

> What is wrong with using uevents otherwise? What would be another way to
> asyncronousely notify userspace of things happening in kernel, other
> than though pseudo filesystem files (procfs, sysfs)?

The question is how to relay error details, and how to transport that
information to userpace. Uevents have no state, and the information is
lost after the event. Uevents can not block, they need to finish in
userspace immediately, you can not queue the up or anything else, it
would block other operations. Uevents can _never_ be used to transport
high frequent event streams. They might render the entire system
unusable, if you have lots of devices and many errors.

They could be used to get attention when a superblock does a one-time
transition from "clean" to "error", everything else would just get us
into serious trouble later.

Thanks,
Kay
