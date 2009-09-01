Return-Path: <linux-kernel-owner+w=401wt.eu-S1753882AbZIALSI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbZIALSI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 07:18:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753821AbZIALSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 07:18:07 -0400
Received: from science.horizon.com ([71.41.210.146]:51062 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753588AbZIALSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 07:18:06 -0400
Date: 1 Sep 2009 07:18:03 -0400
Message-ID: <20090901111803.11027.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, neilb@suse.de
Subject: Re: raid is dangerous but that's secret (was Re: [patch] ext2/3:
Cc: david@lang.hm, linux-doc@vger.kernel.org, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org, pavel@ucw.cz
In-Reply-To: <4a2c5faeb04cab59af9ba6ab512c9916.squirrel@neil.brown.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> An embedded checksum, no matter how good, can't tell you if
>> the data is stale; you need a way to distinguish versions in the pointer.

> I would disagree with that.
> If the embedded checksum is a function of both the data and the address
> of the data (in whatever address space seems most appropriate) then it can
> still verify that the data found with the checksum is the data that was
> expected.
> And storing the checksum with the data (where it is practical) means
> index blocks can be more dense so on average fewer accesses to storage
> are needed.

I must not have been clear.  Originally, block 100 has contents version 1.
This includes a correctly computed checksum.

Then you write version 2 of the data there.  But there's a bit error in
the address and the write goes to block 256+100 = 356.  So block
100 still has the version 1 contents, complete with valid checksum.
(Yes, block 356 is now corrupted, but perhaps it's not even allocated.)

Then we go to read block 100, find a valid checksum, and return incorrect
data.  Namely, version 1 data, when we expact and want version 2.

Basically, the pointer has to say which *version* of the data it points to,
not just the block address.  Otherwise, it can't detect a missing write.

If density is a big issue, then including a small version field is a
possibility.
