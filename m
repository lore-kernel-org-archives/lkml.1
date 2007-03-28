Return-Path: <linux-kernel-owner+w=401wt.eu-S932738AbXC1QP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932738AbXC1QP2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 12:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932787AbXC1QP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 12:15:28 -0400
Received: from wr-out-0506.google.com ([64.233.184.236]:8241 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932738AbXC1QP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 12:15:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RkWpInaS9Zp5b05X/YaEpuJRGlt7eClMZP8EYiELIb6ZmQTe0YG2WNp7Iv8lYMZMmaGHNce/fZ2gvucbXiv3+RNzXr9vUKyzhb1cC2vve/lXny1LngbGHyWDgN1eZFfWAS5yZhFB9WqOB2oRGJ5/Fu+n7SM9sfw0KDXlsx+jhPQ=
Message-ID: <4ae3c140703280915n5a310ee6se300f6a7487bbe10@mail.gmail.com>
Date: Wed, 28 Mar 2007 12:15:26 -0400
From: "Xin Zhao" <uszhaoxin@gmail.com>
To: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Linux page cache issue?
In-Reply-To: <alpine.DEB.0.83.0703281157010.2527@sigma.j-a-k-j.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4ae3c140703272345y3b3cb3cexf4c4b63e0035d5b9@mail.gmail.com>
	 <1175091028.12882.15.camel@kleikamp.austin.ibm.com>
	 <4ae3c140703280839q72164accic94666d7801243c1@mail.gmail.com>
	 <alpine.DEB.0.83.0703281157010.2527@sigma.j-a-k-j.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

You are right. If the device is very big, the radix tree could be huge
as well. Maybe the lookup it not that cheap. But the per-device tree
can be optimized too. A simple way I can immediately image is: evenly
split a device into N parts by the sector numbers. For each part, we
maintain a radix tree. Let's do a math. Suppose I have a 32G partition
(2^35 bytes) and each data block is 4K bytes (2^12).  So the partition
has 2^23 blocks. I divide the blocks into 1024 (2^12) groups. Each
group will only have 2^11 blocks. With radix tree, the average lookup
overhead for each tree would be log(2^11) steps. That is 11 in-memory
tree traverse to locate a page. This cost seems to be acceptable. I
don't really measure it though. As to the memory used for maintain the
radix trees, I believe it is trivial considering the memory size of
modern computers.

Xin

On 3/28/07, John Anthony Kazos Jr. <jakj@j-a-k-j.com> wrote:
> > The lookup of the per-device radix tree may incur some overhead. But
> > compared to the slow disk access, looking up an in-memory radix tree is
> > much cheaper and should be trivial, I guess.
>
> I would consider whether or not it really is trivial. You'd have to think
> hard about just how much of your filesystem is going to be sharing data
> blocks. If you fail to find in the per-file tree, then fail to find in the
> per-device tree, then still have to read the block from the device, and
> this is happening too often, then the additional overhead of the
> per-device tree check for non-cached items may end up cancelling the
> savings for cached items.
>
