Return-Path: <linux-kernel-owner+w=401wt.eu-S1756082AbYKPXF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082AbYKPXF4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 18:05:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754776AbYKPXFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 18:05:19 -0500
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:40675 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753678AbYKPXFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 18:05:10 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Date:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=H+vKse9LjE/W0oD+25KN7nl6kYae/I579MprbvNg7uw1OAdo+kJNGuXMrfOEQLiovaODHw2A/0bw3OKjAiQumDTQ3tSsvV1xb8eAGTL3SMRG+QoIhb3VRJAdSnDaG+QZWBm9W+VxpaNmkyoV0ZbqJt17mG7e8RhkV4xZZWbXNjA=  ;
X-YMail-OSG: lY94w9MVM1kJI_ohhpsqcdn8loNyLNhPT_BIc2wNzqnQqy5M2NKXc2ph9Rrn_UzS2ykhXvXcaBqh5RaY1k97Eayvtxl9bi40gzXsk.uHQK1TFgxL6iVIAJAg1MG.LCsit4I-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mark Brown <broonie@sirena.org.uk>
Subject: Re: [patch 2.6.28-rc3] regulator: add REGULATOR_MODE_OFF
User-Agent: KMail/1.9.10
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>
References: <200811091531.46003.david-b@pacbell.net> <200811141715.14804.david-b@pacbell.net> <20081115043753.GA23711@sirena.org.uk>
In-Reply-To: <20081115043753.GA23711@sirena.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
Date: Sun, 16 Nov 2008 12:28:37 -0800
Message-Id: <200811161228.37700.david-b@pacbell.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First the easily addressed points:

On Friday 14 November 2008, Mark Brown wrote:
> On Fri, Nov 14, 2008 at 05:15:14PM -0800, David Brownell wrote:
> > On Thursday 13 November 2008, Mark Brown wrote:
> > > On Thu, Nov 13, 2008 at 11:40:15AM -0800, David Brownell wrote:
> 
> > > If reporting the full state via get_mode() the error reporting case in
> > > particular would seem to be more involved than adding an off state -
> 
> > In that case it would be normal to return some error code.  I always
> > like -ERANGE in such cases -- result is out-of-range.  The sysfs code
> > will already report "unknown".
> 
> I suspect that's due to the use of a bitmask but I do agree that there
> should at least be a facility to report a failure to determine the mode.
> 
> I'm not sure that regulation failures fit in there, though - I do feel
> it's still useful to report the state the hardware is attempting to
> operate in since that may well have a bearing on why the error has
> occurred (for example, running a regulator in a mode when trying to
> supply a load it can't support).

That would be an argument for a new "requested_mode" attribute ...
I already sent a patch with that change, since you seemed to like
that model.  That argument makes me feel such an attribute might
actually be useful.


> > ... though, hmm, I observe that regulator_ops calls returning modes
> > all return "unsigned".  That's clearly broken; it prevents error
> > reporting.  And in fact, the wm8350 get_mode() code returns -EINVAL...
> 
> Yes, something more like BUG() would be more appropriate there - that's
> handling the case of regulators that just aren't supported.

I'd never advise BUG() for such nonfatal driver-goofed-itself cases!
But that's beside the point.

When there is for example a communication error when talking to the
regulator, it should be easy to report that error.  I can imagine for
example a regulator on a device connected via USB, where disconnection
would cause errors on all further requests.  Even with I2C, errors are
not unknown.


> > > Right, if we assume that it reports the instantaneous hardware state.
> 
> > Something sure needs to do that... and there's no point to even
> > having a get_mode() call if that's not what it does.  If the goal
> > is to remember what Linux requested, the framework should have
> > been doing it.
> 
> When I say the state Linux requested what I really mean is "the state
> that is currently being requested in the hardware via the control
> interface used by Linux" rather than the last value that was set via the
> API.

I was hoping the interface would become *simpler* (not harder) to
explain and understand ... :(

Why would those values be different, anyway?  Shouldn't it be an 
error if Linux requests something different from what it accepted
through regulator_ops.set_mode()?


> > This is all extremely young code, and barely used yet; this
> > is a common type of interface bug to find at that stage of any
> > framework's development.  So I'm saying:  need fixing soon.
> 
> No argument about there being room for improvement here.

Good on that!  :)


> > > This caters for any configuration 
> > > changes outside of software control and would let errors report without
> > > masking any other physical state.
> 
> > Of the current set of status reporting calls, get_mode() is the
> > only one which can't report errors.  I don't see any need to cater
> > any further than letting it report errors, and the actual status.
> 
> What is actual status, though?  Is it what's configured in the hardware,
> what the hardware is actually managing to do or something else?

Status would be the output produced by the hardware based
on all its inputs ... including mode and enable requests
from Linux and potentially other agents, and the load that's
currently presented to the regulator hardware.

So with a hypothetical MODE_BEST, status might be "normal"
or "idle" in non-error cases.   Or "off"; or "error", and
for now I'm not assuming much effort to report fault details.

- Dave

