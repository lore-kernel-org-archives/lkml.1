Return-Path: <linux-kernel-owner+w=401wt.eu-S1752439AbZG3WCH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439AbZG3WCH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 18:02:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862AbZG3WCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 18:02:06 -0400
Received: from smtp-out.google.com ([216.239.45.13]:56360 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819AbZG3WCF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 18:02:05 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=DozAVbA+ln5Iyrjw0twRG6gwfXmgL79Gnlpqcdz1BYlWW7Zx4ph/zhG/GQvToOINb
	gTNwtOTooT40K4Th6HzZQ==
MIME-Version: 1.0
In-Reply-To: <20090730213956.GH12579@kernel.dk>
References: <1786ab030907281211x6e432ba6ha6afe9de73f24e0c@mail.gmail.com>
	 <20090730213956.GH12579@kernel.dk>
Date: Thu, 30 Jul 2009 15:01:59 -0700
Message-ID: <33307c790907301501v4c605ea8oe57762b21d414445@mail.gmail.com>
Subject: Re: Bug in kernel 2.6.31, Slow wb_kupdate writeout
From: Martin Bligh <mbligh@google.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Chad Talbott <ctalbott@google.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, wfg@mail.ustc.edu.cn,
       Michael Rubin <mrubin@google.com>, Andrew Morton <akpm@google.com>,
       sandeen@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 30, 2009 at 2:39 PM, Jens Axboe<jens.axboe@oracle.com> wrote:
> On Tue, Jul 28 2009, Chad Talbott wrote:
>> I run a simple workload on a 4GB machine which dirties a few largish
>> inodes like so:
>>
>> # seq 10 | xargs -P0 -n1 -i\{} dd if=/dev/zero of=/tmp/dump\{}
>> bs=1024k count=100
>>
>> While the dds are running data is written out at disk speed.  However,
>> once the dds have run to completion and exited there is ~500MB of
>> dirty memory left.  Background writeout then takes about 3 more
>> minutes to clean memory at only ~3.3MB/s.  When I explicitly sync, I
>> can see that the disk is capable of 40MB/s, which finishes off the
>> files in ~10s. [1]
>>
>> An interesting recent-ish change is "writeback: speed up writeback of
>> big dirty files."  When I revert the change to __sync_single_inode the
>> problem appears to go away and background writeout proceeds at disk
>> speed.  Interestingly, that code is in the git commit [2], but not in
>> the post to LKML. [3]  This is may not be the fix, but it makes this
>> test behave better.
>
> Can I talk you into trying the per-bdi writeback patchset? I just tried
> your test on a 16gb machine, and the dd's finish immediately since it
> wont trip the writeout at that percentage of dirty memory. The 1GB of
> dirty memory is flushed when it gets too old, 30 seconds later in two
> chunks of writeout running at disk speed.

How big did you make the dds? It has to be writing more data than
you have RAM, or it's not going to do anything much interesting ;-)
