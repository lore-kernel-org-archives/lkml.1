Return-Path: <linux-kernel-owner+w=401wt.eu-S1755461AbYGSSko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461AbYGSSko (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 14:40:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756331AbYGSSk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 14:40:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45238 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756106AbYGSSk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 14:40:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: linux-next: Tree for July 17: early crash on x86-64
Date: Sat, 19 Jul 2008 20:42:05 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Alexander Beregalov <a.beregalov@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@parisplace.org>
References: <20080718012842.690b8346.sfr@canb.auug.org.au> <a4423d670807180652y352e66lfe04d2b33d2ed176@mail.gmail.com> <20080719035231.GU28946@ZenIV.linux.org.uk>
In-Reply-To: <20080719035231.GU28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807192042.06988.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 19 of July 2008, Al Viro wrote:
> On Fri, Jul 18, 2008 at 05:52:23PM +0400, Alexander Beregalov wrote:
> > 2008/7/18 Rafael J. Wysocki <rjw@sisk.pl>:
> > > This one crashes all of my x86-64 test boxes early during boot.
> > The same problem with next-20080718.
> > Unfortunatelly I do not have serial console on that host.
> 
> vfs-next/net-next conflict; apply the patch below on top of the merge.

That helped, thanks.

But next it ran into the BUG_ON() in line 883 of security/selinux/avc.c .
Disabling selinux made the kernel boot, finally.


> diff --git a/net/sysctl_net.c b/net/sysctl_net.c
> index b91a5de..2240a9e 100644
> --- a/net/sysctl_net.c
> +++ b/net/sysctl_net.c
> @@ -44,13 +44,6 @@ static struct ctl_table_root net_sysctl_root = {
>  	.lookup = net_ctl_header_lookup,
>  };
>  
> -static LIST_HEAD(net_sysctl_ro_tables);
> -static struct list_head *net_ctl_ro_header_lookup(struct ctl_table_root *root,
> -		struct nsproxy *namespaces)
> -{
> -	return &net_sysctl_ro_tables;
> -}
> -
>  static int net_ctl_ro_header_perms(struct ctl_table_root *root,
>  		struct nsproxy *namespaces, struct ctl_table *table)
>  {
> @@ -61,7 +54,6 @@ static int net_ctl_ro_header_perms(struct ctl_table_root *root,
>  }
>  
>  static struct ctl_table_root net_sysctl_ro_root = {
> -	.lookup = net_ctl_ro_header_lookup,
>  	.permissions = net_ctl_ro_header_perms,
>  };
>  
> @@ -89,6 +81,7 @@ static __init int sysctl_init(void)
>  	if (ret)
>  		goto out;
>  	register_sysctl_root(&net_sysctl_root);
> +	setup_sysctl_set(&net_sysctl_ro_root.default_set, NULL, NULL);
>  	register_sysctl_root(&net_sysctl_ro_root);
>  out:
>  	return ret;
> 
> 


