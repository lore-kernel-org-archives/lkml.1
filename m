Return-Path: <linux-kernel-owner+w=401wt.eu-S1753490AbYGCQel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490AbYGCQel (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 12:34:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751830AbYGCQeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 12:34:31 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:43498 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751222AbYGCQea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 12:34:30 -0400
Subject: Re: [PATCH 001/002] linux-input:  bcm5974-0.31: fixed resource
	leak, removed work struct, device data struct introduced
From: Henrik Rydberg <rydberg@euromail.se>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       dmitry.torokhov@gmail.com, robfitz@273k.net, jikos@jikos.cz,
       vojtech@suse.cz, dmonakhov@openvz.org, linux-usb@vger.kernel.org
In-Reply-To: <20080701155925.a4c00a8e.akpm@linux-foundation.org>
References: <1214653629.10495.11.camel@alnilam>
	 <20080701155925.a4c00a8e.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 03 Jul 2008 18:33:40 +0200
Message-Id: <1215102820.4138.17.camel@alnilam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.35.11
X-Scan-Result: No virus found in message 1KERlN-0005JX-8E.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1KERlN-0005JX-8E 57707d73881069e9a4cd2a24542db8d9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-01 at 15:59 -0700, Andrew Morton wrote:
> > +  }
> > +
> > +  button = data[1];
> > +
> > +  /* only report button state changes */
> > +  if (button != dev->bt_state) {
> > +    input_report_key(dev->input, BTN_LEFT, button);
> > +    input_sync(dev->input);
> > +  }
> > +
> > +  dev->bt_state = button;
> > +
> > + exit:
> > +  retval = usb_submit_urb(dev->bt_urb, GFP_ATOMIC);
> 
> GFP_ATOMIC is a red flag.  Is this quite unrelaible allocation mode
> really needed here?

Being new to kernel work, I rely a lot on how other drivers work.
However, doing some reading, these are my observations:

* The URB works in interrupt mode.

* The call to usb_submit_urb above is within a completion handler.

* From what I read on kerneltrap (2.6.22), such URBs should be
resubmitted using the ATOMIC method. Maybe this changed, I could not
tell.

* Personally, I am starting to worry about concurrency races, with the
two URBs writing to the same input device. I suppose it depends on
whether they are issued on the same interrupt or not? Spin locks?

Best regards,
Henrik Rydberg


