Return-Path: <linux-kernel-owner+w=401wt.eu-S1753604AbXJ2Ue2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604AbXJ2Ue2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 16:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753256AbXJ2UeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 16:34:20 -0400
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:17814 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbXJ2UeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 16:34:19 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [stable] 2.6.23 regression: top displaying 9999% CPU usage
Date: Mon, 29 Oct 2007 21:33:48 +0100
User-Agent: KMail/1.9.7
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>, Frans Pop <elendil@planet.nl>,
       Chuck Ebbert <cebbert@redhat.com>, Greg KH <greg@kroah.com>,
       stable@kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
References: <200710122231.50739.elendil@planet.nl> <4725D2A5.1050908@linux.vnet.ibm.com> <20071029200425.GA830@elte.hu>
In-Reply-To: <20071029200425.GA830@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710292133.48125.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 29. Oktober 2007 schrieb Ingo Molnar:
> i've got a patch from Peter queued up. (see below) This should fix the 
> main issue.
[...]
> --- linux.orig/fs/proc/array.c
> +++ linux/fs/proc/array.c
> @@ -358,7 +358,8 @@ static cputime_t task_utime(struct task_
>  	}
>  	utime = (clock_t)temp;
> 
> -	return clock_t_to_cputime(utime);
> +	p->prev_utime = max(p->prev_utime, clock_t_to_cputime(utime));
> +	return p->prev_utime;
>  }
[...]

I dont think it will work. It will make utime monotic, but stime can still 
decrease. For example let sum_exec_runtime increase by a tiny little bit while
utime will get a full additional tick. stime is sum-utime. So stime can still
go backwards. So I think that we need this kind of logic for stime as well, 
no?

Christian



