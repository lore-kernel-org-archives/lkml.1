Return-Path: <linux-kernel-owner+w=401wt.eu-S1758924AbZE0ISI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758924AbZE0ISI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 04:18:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756410AbZE0IRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 04:17:55 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:46319 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030AbZE0IRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 04:17:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WRgTql/lyRVj96/ruXsgpz05J1IDvR7cvTQfPTKiR3txKtbWXftZ2xbBZPWXP8y2IQ
         ZZX6+jAsmYg5mDsKElSO9FvhH6/Erib0Jx26ufTYEstL3FDRZQDbItsL6lAf52s1v7+R
         5b/+y9nTc5ZLIWt++h+cb8KzxAxLW4jYhT9J0=
Date: Wed, 27 May 2009 10:17:50 +0200
From: Andrea Righi <righi.andrea@gmail.com>
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: vgoyal@redhat.com, guijianfeng@cn.fujitsu.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, jens.axboe@oracle.com,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       agk@redhat.com, dm-devel@redhat.com, snitzer@redhat.com,
       m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org
Subject: Re: [PATCH] io-controller: Add io group reference handling for
	request
Message-ID: <20090527081749.GA7237@linux>
References: <20090518140114.GB27080@redhat.com> <20090518143921.GE3113@linux> <20090526.203424.39179999.ryov@valinux.co.jp> <20090527.155631.226800550.ryov@valinux.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090527.155631.226800550.ryov@valinux.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 03:56:31PM +0900, Ryo Tsuruta wrote:
> > I think that only putting the hook in try_to_unmap() doesn't work
> > correctly, because IOs will be charged to reclaiming processes or
> > kswapd. These IOs should be charged to processes which cause memory
> > pressure.
> 
> Consider the following case:
> 
>   (1) There are two processes Proc-A and Proc-B.
>   (2) Proc-A maps a large file into many pages by mmap() and writes
>       many data to the file.
>   (3) After (2), Proc-B try to get a page, but there are no available
>       pages because Proc-A has used them.
>   (4) kernel starts to reclaim pages, call try_to_unmap() to unmap
>       a page which is owned by Proc-A, then blkio_cgroup_set_owner()
>       sets Proc-B's ID on the page because the task's context is Proc-B.
>   (5) After (4), kernel writes the page out to a disk. This IO is
>       charged to Proc-B.
> 
> In the above case, I think that the IO should be charged to a Proc-A,
> because the IO is caused by Proc-A's memory pressure. 
> I think we should consider in the case without memory and swap
> isolation.

mmmh.. even if they're strictly related I think we're mixing two
different problems in this way: memory pressure control and IO control.

It seems you're proposing something like the badness() for OOM
conditions to charge swap IO depending on how bad is a cgroup in terms
of memory consumption. I don't think this is the right way to proceed,
also because we already have the memory and swap control.

-Andrea
