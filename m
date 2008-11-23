Return-Path: <linux-kernel-owner+w=401wt.eu-S1752376AbYKWVHQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752376AbYKWVHQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 16:07:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751043AbYKWVHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 16:07:04 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:23253 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbYKWVHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 16:07:01 -0500
Message-ID: <4929C5C8.7090008@oracle.com>
Date: Sun, 23 Nov 2008 13:06:16 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       Alexander Viro <viro@ftp.linux.org.uk>, srostedt@redhat.com,
       a.p.zijlstra@chello.nl, sandmann@daimi.au.dk,
       linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: [PATCH] vfs, seqfile: make mangle_path() global
References: <1227353328-16104-1-git-send-email-edwintorok@gmail.com> <1227353328-16104-3-git-send-email-edwintorok@gmail.com> <20081123084737.GE30453@elte.hu>
In-Reply-To: <20081123084737.GE30453@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4929C5CD.0021:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Török Edwin <edwintorok@gmail.com> wrote:
> 
>>  fs/seq_file.c            |   14 +++++++-
>>  include/linux/seq_file.h |    1 +
> 
> Note, i've split these bits out into a separate patch - see it 
> attached below.
> 
> 	Ingo
> 
> ------------------>
> From 74e2f334f4440cbcb63e9ebbcdcea430d41bdfa3 Mon Sep 17 00:00:00 2001
> From: =?utf-8?q?T=C3=B6r=C3=B6k=20Edwin?= <edwintorok@gmail.com>
> Date: Sat, 22 Nov 2008 13:28:48 +0200
> Subject: [PATCH] vfs, seqfile: make mangle_path() global
> MIME-Version: 1.0
> Content-Type: text/plain; charset=utf-8
> Content-Transfer-Encoding: 8bit
> 
> Impact: expose new VFS API
> 
> make mangle_path() available, as per the suggestions of Christoph Hellwig
> and Al Viro:
> 
>   http://lkml.org/lkml/2008/11/4/338
> 
> Signed-off-by: Török Edwin <edwintorok@gmail.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  fs/seq_file.c            |   14 +++++++++++++-
>  include/linux/seq_file.h |    1 +
>  2 files changed, 14 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/seq_file.c b/fs/seq_file.c
> index eba2eab..f5b61cc 100644
> --- a/fs/seq_file.c
> +++ b/fs/seq_file.c
> @@ -357,7 +357,18 @@ int seq_printf(struct seq_file *m, const char *f, ...)
>  }
>  EXPORT_SYMBOL(seq_printf);
>  
> -static char *mangle_path(char *s, char *p, char *esc)
> +/**
> + * 	mangle_path - mangle and copy path to buffer beginning
> + * 	@s - buffer start
> + * 	@p - beginning of path in above buffer
> + *      @esc - set of characters that need escaping

Format for function parameters is:

 * @esc: set of characters that need escaping

please.  (i.e., use : instead of -)

> + *
> + *      Copy the path from @p to @s, replacing each occurrence of character from
> + *      @esc with usual octal escape.
> + *      Returns pointer past last written character in @s, or NULL in case of
> + *      failure.
> + */
> +char *mangle_path(char *s, char *p, char *esc)
>  {
>  	while (s <= p) {
>  		char c = *p++;
> @@ -376,6 +387,7 @@ static char *mangle_path(char *s, char *p, char *esc)
>  	}
>  	return NULL;
>  }
> +EXPORT_SYMBOL_GPL(mangle_path);
>  
>  /*
>   * return the absolute path of 'dentry' residing in mount 'mnt'.
> diff --git a/include/linux/seq_file.h b/include/linux/seq_file.h
> index dc50bcc..b3dfa72 100644
> --- a/include/linux/seq_file.h
> +++ b/include/linux/seq_file.h
> @@ -34,6 +34,7 @@ struct seq_operations {
>  
>  #define SEQ_SKIP 1
>  
> +char *mangle_path(char *s, char *p, char *esc);
>  int seq_open(struct file *, const struct seq_operations *);
>  ssize_t seq_read(struct file *, char __user *, size_t, loff_t *);
>  loff_t seq_lseek(struct file *, loff_t, int);


-- 
~Randy
