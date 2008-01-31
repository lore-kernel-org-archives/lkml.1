Return-Path: <linux-kernel-owner+w=401wt.eu-S1756931AbYAaBXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931AbYAaBXz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 20:23:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752907AbYAaBXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 20:23:47 -0500
Received: from py-out-1112.google.com ([64.233.166.180]:55835 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611AbYAaBXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 20:23:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NBu/1ysnYm+yqvj/LROXSuWeMFWSy+Tk7Ptfg69P12+g1bgG/ZUpXDTQJYRcP4uWcW86fSAxh27451Wt/cbDEu1n2MDLwx4gdoKEtGK/zCX0Vj784FYvHBCgArRti8CxltItAh4+6HOagU+F3G7HeJRWdfOHBSgkBzKMYoQN8jQ=
Message-ID: <524f69650801301723w2f186f73h2cb30a6a30793def@mail.gmail.com>
Date: Wed, 30 Jan 2008 19:23:44 -0600
From: "Steve French" <smfrench@gmail.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Subject: Re: [2.6 patch] remove smbfs
Cc: "Adrian Bunk" <bunk@kernel.org>, sfrench@samba.org,
       samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0801302003560.13036@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080128220835.GF8767@does.not.exist>
	 <Pine.LNX.4.64.0801301923450.13036@fbirervta.pbzchgretzou.qr>
	 <524f69650801301053s370c9a2fpd03bf31616e37d9c@mail.gmail.com>
	 <Pine.LNX.4.64.0801302003560.13036@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 30, 2008 1:05 PM, Jan Engelhardt <jengelh@computergmbh.de> wrote:
>
> On Jan 30 2008 12:53, Steve French wrote:
> >I have mounted to Windows98 a few months ago with no problems (other
> >than a few restrictions like you can't set the file times via utimes).
> > For mounts to Windows98 note that you have to specify the server
> >netbios name on the mount (since it is not the same as the DNS name).
> >In your example your would need to specify "servernetbiosname=WIN98"
> >in the mount options (until mount.cifs autoretries with
> >servernetbiosname assumed to be the beginning of the UNC name - note
> >that later servers have a dummy netbios name that is used so this
> >mount option is only needed for OS/2 and Win9x).
>
> Ok that works. I had tried "netbiosname" but not "servernetbiosname"
> (only fuzzy memories from the last win98 encounter and the suggestion
> to use netbiossomething).
>
> I think servernetbiosname should implicitly be assumed to be the
> same as the //hostpart/ when it's not explicitly specified, no?

Unfortunately, it is not quite that easy since there is a default
"dummy" netbiosname that you are supposed to specify.

The default netbios name is supposed to be "*SMBSERVER" in the RFC1001
session init request (this allows you to connect to the default
netbiosname on the target ip address), but for servers older than
about 1997, and Windows9x, that name is not supported by default and
that field in the session initialize request must contain the actual
netbiosname.   Although using the host name of the server is a good
first guess - the netbiosname does not have to match the tcp host name
(and often differs in more than simply being uppercase and limited to
15 bytes).

There is retry which can be tried.  When the server does not listen on
port 445 and mount fails to *SMBSERVER on port 139 (and retry using
the uppercased tcp name as the netbios name fails) - we can try to do
an "adapter status" rfc1001 call to the ip address of the target and
pick the first netbiosname (or at least the first one that ends with
the server suffix - ie a byte of 0x20 for byte 16 of the netbios
name).   This complicates the mount.cifs helpers retry logic and
adding rfc1001 adapter status code into the kernel also would be a few
hundred lines of kernel code for little benefit if any for current
servers, but it could be done.   Simply adding the one retry (for
failed mounts using servernetbiosname=<target-host-name> would
probably take care of most cases.



-- 
Thanks,

Steve
