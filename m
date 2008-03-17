Return-Path: <linux-kernel-owner+w=401wt.eu-S1755882AbYCQD7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882AbYCQD7n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 23:59:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753139AbYCQD7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 23:59:35 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:54297 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752301AbYCQD7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 23:59:35 -0400
X-Sasl-enc: sgX4mBcCRG3VD5uMjKBGbLlZNgVRePIcCfYczuC7BJeB 1205726373
Date: Mon, 17 Mar 2008 00:34:58 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: LED naming standard for LED class
Message-ID: <20080317033458.GA20486@khazad-dum.debian.net>
References: <1202380503.9519.21.camel@dax.rpnet.com> <20080207213845.GA27862@khazad-dum.debian.net> <1202422388.9519.123.camel@dax.rpnet.com> <20080316181840.GG19825@khazad-dum.debian.net> <1205695756.4524.20.camel@dax.rpnet.com> <20080316194823.GA31782@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080316194823.GA31782@khazad-dum.debian.net>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(changing the subject.  Newcomers, the context is given by commit
6c152beefbf90579d21afc4f7e075b1f801f9a75).

On Sun, 16 Mar 2008, Henrique de Moraes Holschuh wrote:
> On Sun, 16 Mar 2008, Richard Purdie wrote:
> > As I understand it 2.6.26 will lose the limitation on the name size
> > entirely so the problem will go away soon. I don't want to change the
> > existing ABI so changing to what you describe above isn't possible. You
> > could leave the devicename empty if you wish although I'd prefer you not
> > to. Keeping it short might be the best option for 2.6.25.
> 
> Hmm, that means I will have to keep the short names, since I can't very
> much have two different ABIs across several kernel versions... or I will

Ok, I looked at it from various angles, and did some heavy thinking about
it.

Richard, isn't there *any* way to change this new ABI?  It has not been in
any stable mainline release yet, so it is not too late if we do it now.

Even if the lenght limit for sysfs entries (19 chars + NULL) is lifted in
2.6.26, the current proposal that would become stable in 2.6.25 is still
ugly, and not nearly close to the best we could do, IMHO.

The only technical reason I can see for the "devicename" part of the LED
name is to avoid clashes (or as a placeholder when you have no function).
However, it is the least important information for any sort of generic LED
tool (which is the only reason to even bother with a LED naming standard to
begin with), so it certainly should not come first in the name.  And there
are other ways to avoid clashes that waste far less real state than the
device name.

Can't we have "function[:color].<number>" instead?   And allow for a choice
of "devicename" or simply "led" instead of "function" for leds with no
defined or implied function?

It places fields in order of importance (thus it is far more user-friendly),
it wastes less real state (typically just two chars) to avoid clashes, and
it also follows what we already have on other sysfs subsystems (except for
the :color part, and I agree with you that it is a desireable thing to have
in there).

The clash-avoiding ".%d" postfix would be taken care of by the class.  If
two devices are registered with a "battery:green" name, you'd end up with
"battery:green.0" and "battery:green.1".  If just one device tries to
register "battery:yellow", you'd get "battery:yellow.0".

Later (for 2.6.26) I'd also suggest adding the color notion to the *class*
itself, including the notion of "undefined" color.  The class would take
care to add the ":color" part of the node name (when it is not "undefined")
and *also* export the color as an attribute. I can write this patch too, if
you want.

Would you take patches to implement the "function[:color].<ordinal>" naming
scheme, and try to merge them into 2.6.25?  Avoiding a bad ABI becoming
stable *is* an acceptable reason for a late merge.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
