Return-Path: <linux-kernel-owner+w=401wt.eu-S1755920AbZJLNFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920AbZJLNFq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 09:05:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755018AbZJLNFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 09:05:45 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:55199 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbZJLNFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 09:05:45 -0400
Message-ID: <4AD32937.4060001@s5r6.in-berlin.de>
Date: Mon, 12 Oct 2009 15:03:51 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.22) Gecko/20090605 SeaMonkey/1.1.17
MIME-Version: 1.0
To: John Kacur <jkacur@redhat.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>, Jonathan Corbet <corbet@lwn.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vincent Sanders <vince@simtec.co.uk>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH RFC] [PATCH] drivers/scsi/ch.c: Remove BKL in ch_open
References: <alpine.LFD.2.00.0910111443400.3587@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0910111443400.3587@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2009 3:45 PM, John Kacur wrote:
> Locking in ch_open is covered by the spin_lock, it serializes the calls
> to idr_find and scsi_device_get. The BKL appears redundant to me here.

Superficially this looks OK (i.e. no race with driver init in general).
But I do wonder if there isn't already a race condition possible with
the current code, between ch_probe and the file operations.  ch_probe
makes a scsi_changer instance available in the IDR and creates the
corresponding character device file _before_ the scsi_changer instance
is fully initialized.

(Full quote follows for lsml)

> From b385c85bb5c2579e542cfe55475b729325eb65e1 Mon Sep 17 00:00:00 2001
> From: John Kacur <jkacur@redhat.com>
> Date: Sun, 11 Oct 2009 13:06:54 +0200
> Subject: [PATCH] drivers/scsi/ch.c: Remove BKL in ch_open
> 
> Everything in ch_open is covered by a spin_lock, so the lock_kernel is redundant
> Remove it.
> 
> Signed-off-by: John Kacur <jkacur@redhat.com>
> ---
>  drivers/scsi/ch.c |    5 +----
>  1 files changed, 1 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
> index fe11c1d..4ba8b67 100644
> --- a/drivers/scsi/ch.c
> +++ b/drivers/scsi/ch.c
> @@ -579,19 +579,16 @@ ch_open(struct inode *inode, struct file *file)
>  	scsi_changer *ch;
>  	int minor = iminor(inode);
>  
> -	lock_kernel();
>  	spin_lock(&ch_index_lock);
>  	ch = idr_find(&ch_index_idr, minor);
>  
>  	if (NULL == ch || scsi_device_get(ch->device)) {
>  		spin_unlock(&ch_index_lock);
> -		unlock_kernel();
>  		return -ENXIO;
>  	}
> +	file->private_data = ch;
>  	spin_unlock(&ch_index_lock);
>  
> -	file->private_data = ch;
> -	unlock_kernel();
>  	return 0;
>  }
>  


-- 
Stefan Richter
-=====-==--= =-=- -==--
http://arcgraph.de/sr/
