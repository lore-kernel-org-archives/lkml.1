Return-Path: <linux-kernel-owner+w=401wt.eu-S1759384AbYCETYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759384AbYCETYQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 14:24:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754587AbYCETYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 14:24:00 -0500
Received: from phunq.net ([64.81.85.152]:39599 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753941AbYCETX7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 14:23:59 -0500
From: Daniel Phillips <phillips@phunq.net>
To: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [RFC] An alternative interface to device mapper
Date: Wed, 5 Mar 2008 11:23:48 -0800
User-Agent: KMail/1.9.5
Cc: device-mapper development <dm-devel@redhat.com>,
       linux-kernel@vger.kernel.org
References: <22778.1204735199@vena.lwn.net>
In-Reply-To: <22778.1204735199@vena.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803051123.49078.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 March 2008 08:39, Jonathan Corbet wrote:
> Hey, Daniel,
> 
> > In more detail: ddlink is a generic pipe-like interface for controlling 
> > device drivers.
> 
> I'm not in a position to say much about the wider picture at the moment,
> but one quibble comes immediately to mind: why do you create yet another
> communication path into the kernel rather than using netlink, which is
> already there and used in a number of other contexts?

Good question.  It is for the same reason that we are moving away from
unix domain sockets, which also work but are clumsy and force us to
structure the application in a less than desirable way.  One could equally
well ask why it was necessary to invent Netlink when unix domain sockets
already existed.

ddlink is very different from netlink.  Netlink is socket-oriented while
ddlink is file-oriented.  Compare:

 int rc;
 void *msg_head;
 /* create the message headers */
 msg_head = genlmsg_put(skb, pid, seq, type, 0, flags, DOC_EXMPL_C_ECHO, 1);
 if (msg_head == NULL) {
     rc = -ENOMEM;
     goto failure;
 }
 /* add a DOC_EXMPL_A_MSG attribute */
 rc = nla_put_string(skb, DOC_EXMPL_A_MSG, "Generic Netlink Rocks");
 if (rc != 0)
     goto failure;
 /* finalize the message */
 genlmsg_end(skb, msg_head);

static void selnl_add_payload(struct nlmsghdr *nlh, int len, int msgtype, void *data)
{
        switch (msgtype) {
        case SELNL_MSG_SETENFORCE: {
                struct selnl_msg_setenforce *msg = NLMSG_DATA(nlh);

                memset(msg, 0, len);
                msg->val = *((int *)data);
                break;
        }

        case SELNL_MSG_POLICYLOAD: {
                struct selnl_msg_policyload *msg = NLMSG_DATA(nlh);

                memset(msg, 0, len);
                msg->seqno = *((u32 *)data);
                break;
        }

        default:
                BUG();
        }
}

or:

static void selnl_notify(int msgtype, void *data)
{
        int len;
        sk_buff_data_t tmp;
        struct sk_buff *skb;
        struct nlmsghdr *nlh;

        len = selnl_msglen(msgtype);

        skb = alloc_skb(NLMSG_SPACE(len), GFP_USER);
        if (!skb)
                goto oom;

        tmp = skb->tail;
        nlh = NLMSG_PUT(skb, 0, 0, msgtype, len);
        selnl_add_payload(nlh, len, msgtype, data);
        nlh->nlmsg_len = skb->tail - tmp;
        NETLINK_CB(skb).dst_group = SELNLGRP_AVC;
        netlink_broadcast(selnl, skb, 0, SELNLGRP_AVC, GFP_USER);
out:
        return;

nlmsg_failure:
        kfree_skb(skb);
oom:
        printk(KERN_ERR "SELinux:  OOM in %s\n", __FUNCTION__);
to:

  ddlink_post(dd, "hello world", sizeof("hello world"));

With netlink, fd creation is tied to the socket api, which makes things
messier for applications than leaving the method by which an FD is created
up to the module.  We are moving away from sockets because we don't like
the connect.  Netlink would fail to get rid of that annoyance.

Netlink imposes its concept of message codes on the application, whether
or not message codes are appropriate to the problem at hand.  ddlink
leaves that entirely up to the module, and in fact ddsetup does not use
message codes because they would make the application code more verbose.

Ddlink does what I want, simply by exposing basic file operations, while
netlink has all kinds of requirements and diversions not obviously related
to the problem at hand.  Basically, I found Trond did a better job of
inventing an interface than the network guys did.  He just did not package
it up for general use, so I did, and simplified it in the process.

Daniel
