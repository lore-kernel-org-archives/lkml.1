Return-Path: <linux-kernel-owner+w=401wt.eu-S1759255AbXHBSde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759255AbXHBSde (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 14:33:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756323AbXHBSd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 14:33:27 -0400
Received: from stephens.ittc.ku.edu ([129.237.125.220]:52118 "EHLO
	stephens.ittc.ku.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863AbXHBSd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 14:33:26 -0400
Date: Thu, 2 Aug 2007 13:32:51 -0500
From: Noah Watkins <nwatkins@ittc.ku.edu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
       "systemtap@sourceware.org" <systemtap@sourceware.org>
Subject: Re: [patch 0/1] extending low-level markers
Message-ID: <20070802183251.GA15216@ittc.ku.edu>
References: <20070801215723.GA10470@ittc.ku.edu> <20070802164437.GA27003@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070802164437.GA27003@Krystal>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.0.2 (stephens.ittc.ku.edu [129.237.125.220]); Thu, 02 Aug 2007 13:32:51 -0500 (CDT)
X-VirusScan: Clean
X-MailScanner-From: nwatkins@ittc.ku.edu
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/07 12:44 -0400, Mathieu Desnoyers wrote:
> * nwatkins@ittc.ku.edu (nwatkins@ittc.ku.edu) wrote:
> > Mathieu
> > 
> > I have been working with your Kernel Markers infrastructure now for some
> > time and have run into an extendability issue.
> 
> Hi Noah,
> 
> Can you tell us a little bit more about what you are doing with the
> markers ? I guess it could be useful to know so we can get a sense of
> how it fits in the big picture.

We have been maintaining an in-house instrumentation framework. The
instrumenation points we use differ from Kernel Markers in that the desired
callback is attached at compile time. Other than this difference, they
are implemented in much the same way. The biggest difference is that we
have been implicitly encoding the 'type' of instrumenation point by
assigning a particular callback. For example one type of instrumenation
point in our framework has the form:

ds_event(name, int, size_t, void *);

Thus, a ds_event has a definite set of arguments, and some name, which
is compatible with a trace_mark.

We would like to be able to construct a ds_event on top of the low-level
kernel markers and be able to differentiate between a standard trace_mark in
in the markers section, and a trace_mark which actually represents a
ds_event, or another event type.

Granted we could simply match on compatible argument formats, its only
that a separation between types would be nice in order to not touch
markers which are of not interest to us, hence this notion of type.
Our framework would have blindly attached some callback to all
points which had matching argument formats, perhaps many that were not
inserted using ds_event (or some other api built on top of markers).

The biggest problem we are facing now is with a set of points which
cooperate together in the sense that one references the others (or some
other connection topology). For example:

ds_point_start(NAME, params)
ds_point_end(NAME, params)

In this situation ds_point_start collects some data, stashes it in its
private data area,  and ds_point_end references the corresponding
ds_point_start when it fires. The two points are wired up by our
framework (using the marker's private data) and the NAME, in order to
avoid lookups at logging time.

So, in this case the names are the same which logically links them, but
their functionality is different. The difference in functionality could
again be encoded by the 'type' of point.

> The current approach is to use the marker name as a way to specify
> markers "group". If we go with a "flavor" enumeration instead, we would
> have to add an enumeration of every markers users in marker.h, which I
> am a bit reluctant to do.

This would have to be my biggest complaint with the 'flavor' concept as
well. However, if all points in main-line always used no concept of
flavor (or essentially the default flavor) then users wishing to use the
flavor enumeration out of main-line development could do so?

Hope this helps portray more of what we are trying to do.

Noah
