Return-Path: <linux-kernel-owner+w=401wt.eu-S1752929AbZFXVwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929AbZFXVwi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 17:52:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751776AbZFXVwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 17:52:30 -0400
Received: from smtp-out.google.com ([216.239.33.17]:9847 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbZFXVw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 17:52:29 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=F2VoO7GbxQ12i0SxStc8lUXL2b6AInac0IV3YsYN3fVv/k5kVfXr8+NH8S5E5f7bw
	0aeds/8FgSQSuU+QAKyUw==
MIME-Version: 1.0
In-Reply-To: <1245443858-8487-19-git-send-email-vgoyal@redhat.com>
References: <1245443858-8487-1-git-send-email-vgoyal@redhat.com>
	 <1245443858-8487-19-git-send-email-vgoyal@redhat.com>
Date: Wed, 24 Jun 2009 14:52:19 -0700
Message-ID: <6599ad830906241452t76e64815s7d68a22a6e746a59@mail.gmail.com>
Subject: Re: [PATCH 18/20] io-controller: Support per cgroup per device 
	weights and io class
From: Paul Menage <menage@google.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, jbaron@redhat.com,
       agk@redhat.com, snitzer@redhat.com, akpm@linux-foundation.org,
       peterz@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 19, 2009 at 1:37 PM, Vivek Goyal<vgoyal@redhat.com> wrote:
>
> You can use the following format to play with the new interface.
> #echo DEV:weight:ioprio_class > /patch/to/cgroup/policy
> weight=0 means removing the policy for DEV.
>
> Examples:
> Configure weight=300 ioprio_class=2 on /dev/hdb in this cgroup
> # echo /dev/hdb:300:2 > io.policy
> # cat io.policy
> dev weight class
> /dev/hdb 300 2

I think that the read and write should be consistent. Can you just use
white-space separation for both, rather than colon-separation for
writes and white-space separation for reads?

Also, storing device inode paths statically as strings into the
io_policy structure seems wrong, since it's quite possible for the
device node that was used originally to be gone by the time that
someone reads the io.policy file, or renamed, or even replaced with an
inode that refers to to a different block device

My preferred alternatives would be:

- read/write the value as a device number rather than a name
- read/write the block device's actual name (e.g. hda or sda) rather
than a path to the inode

Paul
