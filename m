Return-Path: <linux-kernel-owner+w=401wt.eu-S1756779AbYHSTM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779AbYHSTM3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 15:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751258AbYHSTMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 15:12:19 -0400
Received: from web82201.mail.mud.yahoo.com ([209.191.86.96]:25459 "HELO
	web82201.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752623AbYHSTMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 15:12:18 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=H5ONO3LzUUIlT02Q0sYL2aPRyEhBEMtv3EADQg0U97FLUM3Rs7CAhcJc+ReRzX0mBu+yhHEaJMAAhZWEItg3EwOJxYW0gwytNvQk4u6dtnjF9Y6S8rPi7g5ywGkBO/r2KWbS6mqgy+4grLHAM8qRj1E9GbS1nG0577pJJDKwtec=;
X-YMail-OSG: EyDtAlIVM1lF7TVhJiZ1oZlOWq2DiO6HqJi4W59I0k1muIfL8zA-
Date: Tue, 19 Aug 2008 12:12:17 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: PROBLEM: USB keyboards works only 4 per PC host port
To: Alan Stern <stern@rowland.harvard.edu>, juanslayton@dslextreme.com
Cc: Aivils Stoss <aivils@latnet.lv>, jkosina@suse.cz,
       lud <linux-usb@vger.kernel.org>, linux-kernel@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>,
       linuxconsole-dev@lists.sourceforge.net, linux-input@vger.kernel.org
In-Reply-To: <Pine.LNX.4.44L0.0808191400150.3391-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <681431.40736.qm@web82201.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Alan Stern <stern@rowland.harvard.edu> wrote:

> On Tue, 19 Aug 2008 juanslayton@dslextreme.com wrote:
> > If I understand your analysis, Aivils' problem is because the UHCI
> > controllers are too slow.
> 
> Not just that; it also is a question of scheduling.  The uhci-hcd
> driver isn't very clever about scheduling, and it tries to put all the
> packets into the same frame.  If the packets were distributed among
> multiple frames then the limit would be considerably higher (eight
> times higher in this case).
> 
> I'm not sure of the scheduling details in the ohci-hcd driver; they
> might well be more flexible than in uhci-hcd.  In which case a single
> OHCI controller would be able to handle up to 32 of these keyboards, 
> even though it is no faster than a UHCI controller.

The OHCI scheduling is pretty simple and compact.  I'd think it would
be easy enough to make UHCI do the same sort of thing:  track bandwidth
assigned to 2^N frames (OHCI hardware imposes a smaller limit for N
than UHCI hardware does), and pick the least loaded of those frames to
use for new transfers.  In ohci-q.c see balance(), periodic_{,un}link().

Thing is that would involve changing how UHCI manages periodic transfers;
assuming it hasn't changed those structures since last I looked.

