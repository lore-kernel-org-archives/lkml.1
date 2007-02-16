Return-Path: <linux-kernel-owner+w=401wt.eu-S932516AbXBPRcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932516AbXBPRcV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 12:32:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932568AbXBPRcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 12:32:21 -0500
Received: from mtagate3.de.ibm.com ([195.212.29.152]:34117 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932516AbXBPRcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 12:32:20 -0500
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Organization: IBM
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: Using kevent for event logging?
Date: Fri, 16 Feb 2007 18:33:35 +0100
User-Agent: KMail/1.9.4
Cc: Michael Holzheu <holzheu2@linux.vnet.ibm.com>, akpm@osdl.org,
       mschwid2@de.ltcfwd.linux.ibm.com, heiko.carstens@de.ibm.com,
       linux-kernel@vger.kernel.org
References: <20070216155708.589cd47a.holzheu2@linux.vnet.ibm.com> <20070216150618.GA25878@2ka.mipt.ru>
In-Reply-To: <20070216150618.GA25878@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702161833.35710.holzheu@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Evgeniy,

On Friday 16 February 2007 16:06, Evgeniy Polyakov wrote:
> On Fri, Feb 16, 2007 at 03:57:08PM +0100, Michael Holzheu (holzheu2@linux.vnet.ibm.com) wrote:
> 
> You will need to have implemented two types of operations - userspace
> daemon, which will request some notifications (i.e. notify me when event
> type:1, event:2 is ready), and that one which will mark such requests as
> ready.
> 
> For exactly your purpose I would use userspace kevent notifications - 
> although in documentation I say that such notifications can be
> marked from userspace, you can mark them as ready from kernel too
> (obviously, since kevent is kernel mechanism).
> 
> You can also create own kevent notification type and storage (userspace
> notification requests are stored in the main kevent queue (kevent_user))
> and compile them only for s390 arch and thus do not overlap with
> possible usage of userspace notifications.

Do you think that the following could work?

We create a new notification type, e.g. KEVENT_S390_LOG, which is
registered with kevent_add_callbacks(). Something like:

struct kevent_callbacks sc = {
	.callback = &kevent_s390_log_callback,
	.enqueue = &kevent_s390_log_enqueue,
	.dequeue = &kevent_s390_log_dequeue,
	.flags = 0,
};
kevent_storage_init(NULL, &log_st);
kevent_add_callbacks(&sc, KEVENT_S390_LOG);

Then we have a new kernel event function:

void kevent_s390_log_notify(u32 event)
{
	kevent_storage_ready(&log_st, NULL, event);
}

For each possible event, we define an unique event ID, which can be
requested by the userspace daemon. E.g.:
#define KEVENT_S390_TAPE_LOADED 0x00000001
#define KEVENT_S390_TAPE_UNLOADED 0x00000002

To create an event in the kernel, the notify function is used. E.g.:
kevent_s390_log_notify(KEVENT_S390_TAPE_LOADED);

Each event gets a sequence number, which has to be included somehow
in the kevent (ret_data field?). The event data (e.g. Device number of
the tape drive) has to be stored probably in some additional wraparound
buffer, maybe using relay or something similar.

The userspace daemon basically does the following:

* Register with kevent_ctl() for all interesting events using the unique
  event ID
* Implement kevent_wait()/kevent_commit() loop to get the kernel events
* The Sequence number of each event can be obtained from the ret_data
  field (?)
* The Sequence number can be used to get event data via a second
  kernel interface (using relay or whatever).

Does this sound reasonable?

Michael
