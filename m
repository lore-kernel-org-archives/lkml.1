Return-Path: <linux-kernel-owner+w=401wt.eu-S1760704AbYBAC6I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760704AbYBAC6I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 21:58:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753150AbYBAC5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 21:57:55 -0500
Received: from wx-out-0506.google.com ([66.249.82.231]:20365 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781AbYBAC5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 21:57:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oo0dgH7i+wsYFc9RjbKR9nsW/xk4LKywUh1HMGZ8hFK3NJL74fiI7/bM9UWOJ+s0Byty6oPBDgBytqo0WRoGzb1cy9xm4Fy9obUHK6vHKT5Fhm0voab5BL7LIh9Tot6xl/5bUWyA0VndewmrItn8++cBnH2uuOxpa7i/Juw++A4=
Message-ID: <a8e1da0801311857rca1c9abmbff748d6708b995c@mail.gmail.com>
Date: Fri, 1 Feb 2008 10:57:50 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: [PATCH retry] bluetooth : add conn add/del workqueues to avoid connection fail
Cc: jens.axboe@oracle.com, marcel@holtmann.org, linux-kernel@vger.kernel.org,
       bluez-devel@lists.sourceforge.net, netdev@vger.kernel.org
In-Reply-To: <20080131.183358.229943667.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080130022354.GA3132@darkstar.te-china.tietoenator.com>
	 <20080131130930.GW15220@kernel.dk>
	 <20080201012441.GA2924@darkstar.te-china.tietoenator.com>
	 <20080131.183358.229943667.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 1, 2008 10:33 AM, David Miller <davem@davemloft.net> wrote:
> From: Dave Young <hidave.darkstar@gmail.com>
> Date: Fri, 1 Feb 2008 09:24:41 +0800
>
>
> > On Thu, Jan 31, 2008 at 02:09:30PM +0100, Jens Axboe wrote:
> > > On Wed, Jan 30 2008, Dave Young wrote:
> > > >
> > > > The bluetooth hci_conn sysfs add/del executed in the default workqueue.
> > > > If the del_conn is executed after the new add_conn with same target,
> > > > add_conn will failed with warning of "same kobject name".
> > > >
> > > > Here add btaddconn & btdelconn workqueues,
> > > > flush the btdelconn workqueue in the add_conn function to avoid the issue.
> > > >
> > > > Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
> > > >
> > > > ---
> > > > diff -upr a/net/bluetooth/hci_sysfs.c b/net/bluetooth/hci_sysfs.c
> > > > --- a/net/bluetooth/hci_sysfs.c   2008-01-30 10:14:27.000000000 +0800
> > > > +++ b/net/bluetooth/hci_sysfs.c   2008-01-30 10:14:14.000000000 +0800
> > > > @@ -12,6 +12,8 @@
> > > >  #undef  BT_DBG
> > > >  #define BT_DBG(D...)
> > > >  #endif
> > > > +static struct workqueue_struct *btaddconn;
> > > > +static struct workqueue_struct *btdelconn;
> > > >
> > > >  static inline char *typetostr(int type)
> > > >  {
> > > > @@ -279,6 +281,7 @@ static void add_conn(struct work_struct
> > > >   struct hci_conn *conn = container_of(work, struct hci_conn, work);
> > > >   int i;
> > > >
> > > > + flush_workqueue(btdelconn);
> > > >   if (device_add(&conn->dev) < 0) {
> > > >           BT_ERR("Failed to register connection device");
> > > >           return;
> > > > @@ -313,6 +316,7 @@ void hci_conn_add_sysfs(struct hci_conn
> > > >
> > > >   INIT_WORK(&conn->work, add_conn);
> > > >
> > > > + queue_work(btaddconn, &conn->work);
> > > >   schedule_work(&conn->work);
> > > >  }
> > >
> > > So you queue &conn->work on both btaddconn and keventd_wq?
> >
> > My fault. Thanks for pointing out.
> >
> > new patch as following (some fixes according to marcel's style as well)
>
> Your original patch was already in the tree, so I just checked
> in the relative changes.
>
> Please don't me do this next time :-)

David, sorry for it. Should be more careful.

Thanks :)
