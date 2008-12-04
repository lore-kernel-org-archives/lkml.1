Return-Path: <linux-kernel-owner+w=401wt.eu-S1758974AbYLDWdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758974AbYLDWdu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 17:33:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756716AbYLDWdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 17:33:40 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:44717 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756337AbYLDWdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 17:33:39 -0500
Date: Thu, 4 Dec 2008 16:33:36 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Bryan Donlan <bdonlan@gmail.com>
Cc: mtk.manpages@gmail.com, ebiederm@xmission.com,
       lkml <linux-kernel@vger.kernel.org>, linux-man@vger.kernel.org,
       clg@fr.ibm.com, herbert@13thfloor.at, dev@sw.ru,
       Subrata Modak <subrata@linux.vnet.ibm.com>,
       David Howells <dhowells@redhat.com>
Subject: Re: Could you write some CLONE_NEWUSER?
Message-ID: <20081204223336.GA20990@us.ibm.com>
References: <cfd18e0f0812040720y5cabd2aarbf3912644dea42c4@mail.gmail.com> <20081204190430.GA16026@us.ibm.com> <3e8340490812041218l7b4633fev5126f25a5d33076c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e8340490812041218l7b4633fev5126f25a5d33076c@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Bryan Donlan (bdonlan@gmail.com):
> This is something more of a general question than one about this
> manpage, but how will files owned by user namespaces be represented on
> the underlying filesystem? Since (C, 501) will be meaningless after a
> reboot at the latest, it makes little sense to persist them...

Yeah that's a very interesting question.  Clearly persistant names for
the user namespaces are needed.  Eric very much wanted to avoid having
the user namespaces be explicitly named, so we pursued the path of
having the filesystem handle the naming.  So in my last patchset,
a mount option could register the mounter's user namespace name.
There would be a system-wide policy saying for instance that (B,500)
user namespaces owned by can register themselves at C.

(end of discussion arising from that patchset is here: )
https://lists.linux-foundation.org/pipermail/containers/2008-August/012793.html

In the simplest case of no fs support for user namespaces, the mount
will be 'owned' by the userns which mounted it (no persistant name
needed for that).  Users who are in a different namespace will only get
the 'user other' permission to the file/dir, and may not create files
there (since we wouldn't know which userid to place on it).

Then the fs can support user namespaces - however it wants.  It could
just store (B, 500),(C, 501) in an xattr.  Or it could just store the
userid and userns name of the lowest user (I.e. C and 0), and count on
knowning that (B, 500) owns user namespace C.  We do want to provide
generic helpers in lib/fsuserns.c which any fs could use.

But yes, picking a meaningful persistant name for a user namespace
is an issue.

-serge
