Return-Path: <linux-kernel-owner+w=401wt.eu-S1752157AbXCIPFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157AbXCIPFe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 10:05:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030493AbXCIPFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 10:05:34 -0500
Received: from ra.tuxdriver.com ([70.61.120.52]:4030 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752157AbXCIPFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 10:05:32 -0500
Date: Fri, 9 Mar 2007 09:19:07 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@stusta.de>,
       jgarzik@pobox.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
Subject: Re: 2.6.21-rc2-mm2: drivers/net/wireless/libertas/debugfs.c addr bogosity
Message-ID: <20070309141906.GA3296@tuxdriver.com>
References: <20070306004408.d3f6434d.akpm@linux-foundation.org> <20070307224116.GE3441@stusta.de> <20070307150057.4e6342dc.akpm@linux-foundation.org> <20070309021146.GL4575@bakeyournoodle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070309021146.GL4575@bakeyournoodle.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Probably should copy me and linux-wireless@vger.kernel.org.  Other than
that, this looks fine to me.  I'll queue it up shortly.

John

On Fri, Mar 09, 2007 at 01:11:46PM +1100, Tony Breeds wrote:
> On Wed, Mar 07, 2007 at 03:00:57PM -0800, Andrew Morton wrote:
> > On Wed, 7 Mar 2007 23:41:16 +0100
> > Adrian Bunk <bunk@stusta.de> wrote:
> > 
> > > On Tue, Mar 06, 2007 at 12:44:08AM -0800, Andrew Morton wrote:
> > > >...
> > > > Changes since 2.6.20-rc2-mm1:
> > > >...
> > > >  git-netdev-all.patch
> > > >...
> > > >  git trees
> > > >...
> > > 
> > > drivers/net/wireless/libertas/debugfs.c contains:
> > >   #define item_addr(n) ((u32) &((wlan_adapter *)0)->n)
> > > 
> > > This is wrong on 64bit architectures.
> > 
> > Is OK - it is simply yet another reimplementation of offsetof().  Hint.
> 
> Perhaps something like?
> 
> Against 2.6.21-rc3-mm2
> 
> From: Tony Breeds <tony@bakeyournoodle.com>
> 
> Cleanup drivers/net/wireless/libertas/debugfs.c to use standard kernel macros and functions.
> 
> Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>
> 
> ---
> only compile tested on x86
> 
>  debugfs.c |   41 ++++-------------------------------------
>  1 file changed, 4 insertions(+), 37 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/debugfs.c b/drivers/net/wireless/libertas/debugfs.c
> index 3ad1e03..51dfd20 100644
> --- a/drivers/net/wireless/libertas/debugfs.c
> +++ b/drivers/net/wireless/libertas/debugfs.c
> @@ -1772,8 +1772,8 @@ void libertas_debugfs_remove_one(wlan_private *priv)
>  
>  /* debug entry */
>  
> -#define item_size(n) (sizeof ((wlan_adapter *)0)->n)
> -#define item_addr(n) ((u32) &((wlan_adapter *)0)->n)
> +#define item_size(n)	(FIELD_SIZEOF(wlan_adapter, n))
> +#define item_addr(n)	(offsetof(wlan_adapter, n))
>  
>  struct debug_data {
>  	char name[32];
> @@ -1789,40 +1789,7 @@ static struct debug_data items[] = {
>  	{"psstate", item_size(psstate), item_addr(psstate)},
>  };
>  
> -static int num_of_items = sizeof(items) / sizeof(items[0]);
> -
> -/**
> - *  @brief convert string to number
> - *
> - *  @param s   	   pointer to numbered string
> - *  @return 	   converted number from string s
> - */
> -static int string_to_number(char *s)
> -{
> -	int r = 0;
> -	int base = 0;
> -
> -	if ((strncmp(s, "0x", 2) == 0) || (strncmp(s, "0X", 2) == 0))
> -		base = 16;
> -	else
> -		base = 10;
> -
> -	if (base == 16)
> -		s += 2;
> -
> -	for (s = s; *s != 0; s++) {
> -		if ((*s >= 48) && (*s <= 57))
> -			r = (r * base) + (*s - 48);
> -		else if ((*s >= 65) && (*s <= 70))
> -			r = (r * base) + (*s - 55);
> -		else if ((*s >= 97) && (*s <= 102))
> -			r = (r * base) + (*s - 87);
> -		else
> -			break;
> -	}
> -
> -	return r;
> -}
> +static int num_of_items = ARRAY_SIZE(items);
>  
>  /**
>   *  @brief proc read function
> @@ -1912,7 +1879,7 @@ static int wlan_debugfs_write(struct file *f, const char __user *buf,
>  			if (!p2)
>  				break;
>  			p2++;
> -			r = string_to_number(p2);
> +			r = simple_strtoul(p2, NULL, 0);
>  			if (d[i].size == 1)
>  				*((u8 *) d[i].addr) = (u8) r;
>  			else if (d[i].size == 2)
> Yours Tony
> 
>   linux.conf.au        http://linux.conf.au/ || http://lca2008.linux.org.au/
>   Jan 28 - Feb 02 2008 The Australian Linux Technical Conference!
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
John W. Linville
linville@tuxdriver.com
