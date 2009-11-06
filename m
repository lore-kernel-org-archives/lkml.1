Return-Path: <linux-kernel-owner+w=401wt.eu-S1752901AbZKFHKE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901AbZKFHKE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 02:10:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751384AbZKFHKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 02:10:04 -0500
Received: from ozlabs.org ([203.10.76.45]:41497 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270AbZKFHKC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 02:10:02 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Amit Shah <amit.shah@redhat.com>, Anthony Liguori <aliguori@us.ibm.com>
Subject: Re: [PATCH v10 1/1] virtio_console: Add support for multiple ports for generic guest and host communication
Date: Fri, 6 Nov 2009 17:40:02 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, virtualization@linux-foundation.org,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       "Michael S. Tsirkin" <mst@redhat.com>
References: <1257266319-24300-1-git-send-email-amit.shah@redhat.com> <1257266319-24300-2-git-send-email-amit.shah@redhat.com>
In-Reply-To: <1257266319-24300-2-git-send-email-amit.shah@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200911061740.03734.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Nov 2009 03:08:39 am Amit Shah wrote:
> Expose multiple char devices ("ports") for simple communication
> between the host userspace and guest.

OK, I've taken the chance to audit this patch.  I started adding patches
until I got overwhelmed.   It's a complete mess and needs a total rewrite :(

This shows the problem with feeding me a complete driver rewrite in one
big hit.  You've combined lots of changes and techniques in here at once:

1) Moved work out of interrupt handlers and into work_struct.
2) Encapsulated the buffer information in a structure.
3) Added an optional header to the buffer(s).
4) Added control messages.
5) Encapsulated the per-port information into a structure.
6) Allocated a static buffer pool of over 4MB (!)
7) Added an ad-hoc throttling mechanism.
8) Added debugfs support.

Less important nitpicks:
1) Don't call a struct list_head 'next', it confused the crap out of me.
   Call it list or some other non-name.
2) Don't call control messages "internal".  Use ONE good name, ie. control.
3) Don't use list_for_each_safe() to get the head entry of a list.  Your
   use is buggy anyway: buf will never be NULL afterwards.

In summary: this is the one we're going to throw away.

Now I'm going to start again, one patch at a time, and see how that works.

Sorry,
Rusty.
