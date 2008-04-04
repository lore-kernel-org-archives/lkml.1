Return-Path: <linux-kernel-owner+w=401wt.eu-S1758514AbYDDAdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758514AbYDDAdU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 20:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754933AbYDDAdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 20:33:12 -0400
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:43593
	"EHLO mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753987AbYDDAdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 20:33:11 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 0 of 6] [RFC] another attempt at making hotplug memory and xen
	play together
Message-Id: <patchbomb.1207267540@localhost>
Date: Thu, 03 Apr 2008 17:05:40 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi hotplug-memory people,

Here's my current set of WIP patches for using hotplug memory with the
Xen balloon driver.  I'm including all the xen-balloon patches so you
have context for evaluating my hotplug-memory changes.

The gist of the changes to the hotplug memory subsystem is:

- split online_pages up so that users can grow the zones and actually
  online the pages as separate operations,

- remove a bunch of duplicate definitions of online_page() (this is
  just a generally useful cleanup, and it serves to make the later
  change smaller)

- add a section_ops structure, which defines functions to online and
  offline pages.  By default this just calls the standard
  online_page() function, but the xen-balloon driver can install its
  own version which avoids onlining pages with no backing store.

The latter is my generalization of Kamezawa-san's suggestion to put a
hook in the x86-32 online_page() function.  My problem with this idea
is 1) how should the Xen callback know whether it should do anything
special with a given page, and 2) what would happen if two people
wanted to use the hook?  Generally, when we want different kinds of
the same object to have different behaviours, we add an ops structure
and fill it out appropriately, so that's what I decided to do.
Unfortunately threading the ops pointer through the callchain makes
the patch a little large, but not very complex.

Thanks,
	J


