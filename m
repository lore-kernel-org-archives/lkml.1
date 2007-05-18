Return-Path: <linux-kernel-owner+w=401wt.eu-S1757447AbXERRmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447AbXERRmm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 13:42:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754621AbXERRmf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 13:42:35 -0400
Received: from pat.uio.no ([129.240.10.15]:44670 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754614AbXERRme (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 13:42:34 -0400
Subject: Re: [PATCH 12/15] Make NFS client use seq_list_xxx helpers
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Pavel Emelianov <xemul@sw.ru>
Cc: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
In-Reply-To: <464D7A47.7000204@sw.ru>
References: <464D6E87.7060605@sw.ru>  <464D7A47.7000204@sw.ru>
Content-Type: text/plain
Date: Fri, 18 May 2007 13:42:02 -0400
Message-Id: <1179510122.6488.101.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.2, required=12.0, autolearn=disabled, AWL=-0.200)
X-UiO-Scanned: 8A0A718110081DDA820634264464A34624788A0E
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: -1 maxlevel 200 minaction 2 bait 0 mail/h: 402 total 1808829 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-18 at 14:04 +0400, Pavel Emelianov wrote:
> This includes /proc/fs/nfsfs/servers and /proc/fs/nfsfs/volumes
> entries.
> 
> Both need to show the header and use the list_head.
> 
> Signed-off-by: Pavel Emelianov <xemul@openvz.org>

Acked-by: Trond Myklebust <Trond.Myklebust@netapp.com>


> 
> ---
> 
> diff --git a/fs/nfs/client.c b/fs/nfs/client.c
> index 50c6821..10355ec 100644
> --- a/fs/nfs/client.c
> +++ b/fs/nfs/client.c
> @@ -1232,23 +1232,9 @@ static int nfs_server_list_open(struct i
>   */
>  static void *nfs_server_list_start(struct seq_file *m, loff_t *_pos)
>  {
> -	struct list_head *_p;
> -	loff_t pos = *_pos;
> -
>  	/* lock the list against modification */
>  	spin_lock(&nfs_client_lock);
> -
> -	/* allow for the header line */
> -	if (!pos)
> -		return SEQ_START_TOKEN;
> -	pos--;
> -
> -	/* find the n'th element in the list */
> -	list_for_each(_p, &nfs_client_list)
> -		if (!pos--)
> -			break;
> -
> -	return _p != &nfs_client_list ? _p : NULL;
> +	return seq_list_start_head(&nfs_client_list, *_pos);
>  }
>  
>  /*
> @@ -1256,14 +1242,7 @@ static void *nfs_server_list_start(struc
>   */
>  static void *nfs_server_list_next(struct seq_file *p, void *v, loff_t *pos)
>  {
> -	struct list_head *_p;
> -
> -	(*pos)++;
> -
> -	_p = v;
> -	_p = (v == SEQ_START_TOKEN) ? nfs_client_list.next : _p->next;
> -
> -	return _p != &nfs_client_list ? _p : NULL;
> +	return seq_list_next(v, &nfs_client_list, pos);
>  }
>  
>  /*
> @@ -1282,7 +1261,7 @@ static int nfs_server_list_show(struct s
>  	struct nfs_client *clp;
>  
>  	/* display header on line 1 */
> -	if (v == SEQ_START_TOKEN) {
> +	if (v == &nfs_client_list) {
>  		seq_puts(m, "NV SERVER   PORT USE HOSTNAME\n");
>  		return 0;
>  	}
> @@ -1323,23 +1302,9 @@ static int nfs_volume_list_open(struct i
>   */
>  static void *nfs_volume_list_start(struct seq_file *m, loff_t *_pos)
>  {
> -	struct list_head *_p;
> -	loff_t pos = *_pos;
> -
>  	/* lock the list against modification */
>  	spin_lock(&nfs_client_lock);
> -
> -	/* allow for the header line */
> -	if (!pos)
> -		return SEQ_START_TOKEN;
> -	pos--;
> -
> -	/* find the n'th element in the list */
> -	list_for_each(_p, &nfs_volume_list)
> -		if (!pos--)
> -			break;
> -
> -	return _p != &nfs_volume_list ? _p : NULL;
> +	return seq_list_start_head(&nfs_volume_list, *_pos);
>  }
>  
>  /*
> @@ -1347,14 +1312,7 @@ static void *nfs_volume_list_start(struc
>   */
>  static void *nfs_volume_list_next(struct seq_file *p, void *v, loff_t *pos)
>  {
> -	struct list_head *_p;
> -
> -	(*pos)++;
> -
> -	_p = v;
> -	_p = (v == SEQ_START_TOKEN) ? nfs_volume_list.next : _p->next;
> -
> -	return _p != &nfs_volume_list ? _p : NULL;
> +	return seq_list_next(v, &nfs_volume_list, pos);
>  }
>  
>  /*
> @@ -1375,7 +1333,7 @@ static int nfs_volume_list_show(struct s
>  	char dev[8], fsid[17];
>  
>  	/* display header on line 1 */
> -	if (v == SEQ_START_TOKEN) {
> +	if (v == &nfs_volume_list) {
>  		seq_puts(m, "NV SERVER   PORT DEV     FSID\n");
>  		return 0;
>  	}
> 

