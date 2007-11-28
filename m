Return-Path: <linux-kernel-owner+w=401wt.eu-S1754639AbXK1Du3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639AbXK1Du3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 22:50:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751438AbXK1DuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 22:50:11 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:57687 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbXK1DuK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 22:50:10 -0500
Date: Tue, 27 Nov 2007 19:49:29 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: =?utf-8?q?Ferenc_W=C3=A1gner?= <wferi@niif.hu>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/3] Remove trailing NULs from network bonding sysfs
 interface.
Message-Id: <20071127194929.757e4ebe.randy.dunlap@oracle.com>
In-Reply-To: <871wabkxcd.fsf@szonett.ki.iif.hu>
References: <871wabkxcd.fsf@szonett.ki.iif.hu>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Nov 2007 01:49:54 +0100 =?utf-8?q?Ferenc_W=C3=A1gner?= wrote:

> Also remove trailing spaces from multivalued files.
> 
> This fixes output like for example:
> 
> $ od -c /sys/class/net/bond0/bonding/slaves
> 0000000   e   t   h   -   l   e   f   t       e   t   h   -   r   i   g
> 0000020   h   t      \n  \0
> 0000025
> 
> It mostly entails deleting '+1'-s after sprintf() calls: the return value
> of sprintf is the number of characters printed, without the closing NUL,
> ie. exactly what the sysfs interface requires.  The three multivalue
> cases are different, because they also have to swallow back a trailing
> space.
> 
> Signed-off-by: Ferenc Wágner <wferi@niif.hu>
> ---
>  drivers/net/bonding/bond_sysfs.c |   66 +++++++++++++++++--------------------
>  1 files changed, 30 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/net/bonding/bond_sysfs.c b/drivers/net/bonding/bond_sysfs.c
> index b29330d..a3f1b4a 100644
> --- a/drivers/net/bonding/bond_sysfs.c
> +++ b/drivers/net/bonding/bond_sysfs.c
> @@ -86,14 +86,13 @@ static ssize_t bonding_show_bonds(struct class *cls, char *buffer)
>  			/* not enough space for another interface name */
>  			if ((PAGE_SIZE - res) > 10)
>  				res = PAGE_SIZE - 10;
> -			res += sprintf(buffer + res, "++more++");
> +			res += sprintf(buffer + res, "++more++ ");
>  			break;
>  		}
>  		res += sprintf(buffer + res, "%s ",
>  			       bond->dev->name);
>  	}
> -	res += sprintf(buffer + res, "\n");
> -	res++;
> +	if (res) buffer[res-1] = '\n'; /* eat the leftover space */
>  	up_read(&(bonding_rwsem));
>  	return res;
>  }
> @@ -235,14 +234,13 @@ static ssize_t bonding_show_slaves(struct device *d,
>  			/* not enough space for another interface name */
>  			if ((PAGE_SIZE - res) > 10)
>  				res = PAGE_SIZE - 10;
> -			res += sprintf(buf + res, "++more++");
> +			res += sprintf(buf + res, "++more++ ");
>  			break;
>  		}
>  		res += sprintf(buf + res, "%s ", slave->dev->name);
>  	}
>  	read_unlock(&bond->lock);
> -	res += sprintf(buf + res, "\n");
> -	res++;
> +	if (res) buf[res-1] = '\n'; /* eat the leftover space */
>  	return res;
>  }
>  
> @@ -711,10 +709,7 @@ static ssize_t bonding_show_arp_targets(struct device *d,
>  			res += sprintf(buf + res, "%u.%u.%u.%u ",
>  			       NIPQUAD(bond->params.arp_targets[i]));
>  	}
> -	if (res)
> -		res--;  /* eat the leftover space */
> -	res += sprintf(buf + res, "\n");
> -	res++;
> +	if (res) buf[res-1] = '\n'; /* eat the leftover space */
>  	return res;
>  }

Hi,

Patches 1 & 3 use

	if (res) statement;

but the preferred form is

	if (res)
		statement;

Even if this style was already used in the source file, it should
be cleaned up.

Thanks,
---
~Randy
