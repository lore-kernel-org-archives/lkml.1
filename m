Return-Path: <linux-kernel-owner+w=401wt.eu-S1757828AbYAGTOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757828AbYAGTOh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 14:14:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755303AbYAGTO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 14:14:26 -0500
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:45759 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753138AbYAGTOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 14:14:24 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAE4IgkdMROHU/2dsb2JhbACBWKZc
Date: Mon, 7 Jan 2008 14:14:22 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Helge Deller <deller@gmx.de>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: [PATCH] add gcc printf format checks
Message-ID: <20080107191422.GA16682@Krystal>
References: <200801061451.22338.deller@gmx.de> <1199635539.19634.8.camel@localhost> <200801061858.50975.deller@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <200801061858.50975.deller@gmx.de>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:13:04 up 65 days, 18 min,  5 users,  load average: 0.26, 0.32,
	0.26
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Helge Deller (deller@gmx.de) wrote:
> On Sunday 06 January 2008, Joe Perches wrote:
> > __attribute__((format(printf, 1, 2))) seems to be the preferred
> > form. 91 to 1.
> > 
> > I think __printf should be removed from gcc-compiler.h
> > and the only use in include/linux/marker.h converted.
> 
> Personally I would prefer to convert every user over to the smaller __printf() version.
> Nevertheless, below is an updated patch which does what you propose.
> 
> =======================================
> 
> [PATCH] add gcc printf format checks and drop __printf() define
> 
> Trivial patch which adds some missing printf format checking to 
> compat.h and msdos_fs.h. Additionally, it converts the one and
> only user of the __printf macro to __attribute__ (printf).
> 
> Signed-off-by: Helge Deller <deller@gmx.de>
> 
> 
> diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
> index fe23792..3579ac8 100644
> --- a/include/linux/compiler-gcc.h
> +++ b/include/linux/compiler-gcc.h
> @@ -49,7 +49,6 @@
>   */
>  #define __pure				__attribute__((pure))
>  #define __aligned(x)			__attribute__((aligned(x)))
> -#define __printf(a,b)			__attribute__((format(printf,a,b)))
>  #define  noinline			__attribute__((noinline))
>  #define __attribute_const__		__attribute__((__const__))
>  #define __maybe_unused			__attribute__((unused))
> 
> diff --git a/include/linux/marker.h b/include/linux/marker.h
> index 5f36cf9..0fb3f0e 100644
> --- a/include/linux/marker.h
> +++ b/include/linux/marker.h
> @@ -100,7 +100,8 @@ static inline void marker_update_probe_range(struct marker *begin,
>  #define MARK_NOARGS " "
>  
>  /* To be used for string format validity checking with gcc */
> -static inline void __printf(1, 2) __mark_check_format(const char *fmt, ...)
> +static inline void __attribute__((format(printf,1,2)))
> +		   __mark_check_format(const char *fmt, ...)

If the markers are the only user of this macro, it makes sense to change
them and remove the macro. I have no strong opinion about this, but it
is technically ok.

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>


>  {
>  }
>  
> diff --git a/include/linux/compat.h b/include/linux/compat.h
> index 0e69d2c..6d465ad 100644
> --- a/include/linux/compat.h
> +++ b/include/linux/compat.h
> @@ -232,7 +232,7 @@ extern int put_compat_itimerspec(struct compat_itimerspec __user *dst,
>  
>  asmlinkage long compat_sys_adjtimex(struct compat_timex __user *utp);
>  
> -extern int compat_printk(const char *fmt, ...);
> +extern int compat_printk(const char *fmt, ...) __attribute__ ((format(printf,1,2)));
>  extern void sigset_from_compat(sigset_t *set, compat_sigset_t *compat);
>  
>  asmlinkage long compat_sys_migrate_pages(compat_pid_t pid,
> 
> diff --git a/include/linux/msdos_fs.h b/include/linux/msdos_fs.h
> index f950921..dd2b6bb 100644
> --- a/include/linux/msdos_fs.h
> +++ b/include/linux/msdos_fs.h
> @@ -419,7 +419,8 @@ extern int fat_fill_super(struct super_block *sb, void *data, int silent,
>  extern int fat_flush_inodes(struct super_block *sb, struct inode *i1,
>  		            struct inode *i2);
>  /* fat/misc.c */
> -extern void fat_fs_panic(struct super_block *s, const char *fmt, ...);
> +extern void fat_fs_panic(struct super_block *s, const char *fmt, ...)
> +		__attribute__ ((format(printf,2,3)));
>  extern void fat_clusters_flush(struct super_block *sb);
>  extern int fat_chain_add(struct inode *inode, int new_dclus, int nr_cluster);
>  extern int date_dos2unix(unsigned short time, unsigned short date);

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
