Return-Path: <linux-kernel-owner+w=401wt.eu-S934764AbZHERKN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934764AbZHERKN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 13:10:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934738AbZHERKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 13:10:12 -0400
Received: from mail.vyatta.com ([76.74.103.46]:60288 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934741AbZHERKK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 13:10:10 -0400
Date: Wed, 5 Aug 2009 10:10:05 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       Linux Containers <containers@lists.osdl.org>,
       Sachin Sant <sachinp@in.ibm.com>, netdev <netdev@vger.kernel.org>,
       David Miller <davem@davemloft.net>, matthltc@us.ibm.com,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] veth: don't free priv->status until dev->destructor
 (v2)
Message-ID: <20090805101005.6a02f0ae@nehalam>
In-Reply-To: <m1zlaeu5jk.fsf@fess.ebiederm.org>
References: <20090626162418.GA24828@us.ibm.com>
	<20090724124614.6acc5054@nehalam>
	<m1zlaeu5jk.fsf@fess.ebiederm.org>
Organization: Vyatta
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Aug 2009 23:40:47 -0700
ebiederm@xmission.com (Eric W. Biederman) wrote:

> Stephen Hemminger <shemminger@vyatta.com> writes:
> 
> > On Fri, 26 Jun 2009 11:24:18 -0500
> > "Serge E. Hallyn" <serue@us.ibm.com> wrote:
> >
> >> Based on the commit msg on ae0e8e82205c903978a79ebf5e31c670b61fa5b4, it looks
> >
> >>  	ether_setup(dev);
> >> @@ -306,7 +320,7 @@ static void veth_setup(struct net_device *dev)
> >>  	dev->netdev_ops = &veth_netdev_ops;
> >>  	dev->ethtool_ops = &veth_ethtool_ops;
> >>  	dev->features |= NETIF_F_LLTX;
> >> -	dev->destructor = free_netdev;
> >> +	dev->destructor = veth_dev_free;
> >>
> >
> > This is still going to oops if sysfs statistics referenced
> > after module unload because module is unloaded (code is gone)
> > and veth_dev_free no longer exists.
> 
> Has anyone actually seen that cause an oops?
> 
> The reason I am asking is that as I read the code we cannot have
> this problem.  At worst the destructor callback is delayed until:
> 
> veth_exit
>   rtnl_link_unregister
>     rtnl_unlock
>       netdev_run_todo
>         dev->destructor
> 
> 
> Similarly even if the sysfs filehandle is open we have called:
> 
> netdev_unregister_kobject
>   ...
>     sysfs_addrm_finish
>       sysfs_deactivate
> 
> Which guarantees that sysfs_get_active_two will fail and all
> subsequent actions on that file will fail.
> 
> Eric

Sysfs must be safer than it used to be. 
