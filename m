Return-Path: <linux-kernel-owner+w=401wt.eu-S1752740AbZKQMqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740AbZKQMqk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 07:46:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752313AbZKQMqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 07:46:40 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:45603 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbZKQMqj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 07:46:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sArVZb0YSck90fh9QWv7vOpTkztDyvjY3b7zSFBDVmWxjZEJJJyAU2Z0Y0aYU2lYNJ
         Kq2ZIcmv5xEcgZrdvACg5GxtBU8+J07Thc4JN+MgcRdEBCP+QZ8mvJJzETYy+ZlmKHQ0
         +RLwd1lAGGO5BxhYCUjYo2gMs/my9XuTGK0Rw=
MIME-Version: 1.0
In-Reply-To: <20091116153000.GB29479@sirena.org.uk>
References: <ud43sjtaf.wl%morimoto.kuninori@renesas.com>
	 <20091109105858.GB1245@sirena.org.uk>
	 <20091109133136.GC1245@sirena.org.uk>
	 <20091116153000.GB29479@sirena.org.uk>
Date: Tue, 17 Nov 2009 21:46:35 +0900
Message-ID: <aec7e5c30911170446n71031671i48aca11f5276405d@mail.gmail.com>
Subject: Re: Null suspend/resume functions
From: Magnus Damm <magnus.damm@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Kuninori Morimoto <morimoto.kuninori@renesas.com>,
       alsa-devel@alsa-project.org, linux-pm@lists.linux-foundation.org,
       Magnus Damm <damm@opensource.se>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Tue, Nov 17, 2009 at 12:30 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Mon, Nov 09, 2009 at 01:31:36PM +0000, Mark Brown wrote:
>> On Mon, Nov 09, 2009 at 10:58:58AM +0000, Mark Brown wrote:
>> > On Mon, Nov 09, 2009 at 11:54:47AM +0900, Kuninori Morimoto wrote:
>
> Any chance someone from the PM side could comment on the issue below?
>
>> > > +static int fsi_runtime_nop(struct device *dev)
>> > > +{
>> > > + /* Runtime PM callback shared between ->runtime_suspend()
>> > > +  * and ->runtime_resume(). Simply returns success.
>> > > +  *
>> > > +  * This driver re-initializes all registers after
>> > > +  * pm_runtime_get_sync() anyway so there is no need
>> > > +  * to save and restore registers here.
>> > > +  */
>> > > + return 0;
>> > > +}
>> >
>> > This sets off alarm bells but it's perfectly reasonable, especially with
>> > platforms able to put things into a low power state with no explicit
>> > driver code now they can do power domain style things like SH.  I've
>> > CCed in the PM folks since this seems like a perfectly reasonable use
>> > case which ought to be handled more nicely.

On SuperH we have Runtime PM enabled on a few platforms together with
a few updated drivers. The latest driver to become more power aware is
this FSI driver.

It's all quite simple, in the FSI driver we enable the clock to the
FSI hardware using Runtime PM functions, and whenever the clock is
turned off the SuperH specific bus code _may_ decide to call
->runtime_suspend() and turn off the power domain. The "_may_" comes
from the fact that multiple hardware blocks may be grouped together
into a single power domain, and all devices in the power domain must
support Runtime PM and have their clocks disabled before we can turn
off the power.

At this point the SuperH specific platform bus code requires the
callbacks ->runtime_suspend() and ->runtime_resume() to be present. It
may be a good idea to allow them to be NULL in the future or maybe
having some shared functions, but before starting to break out stuff
I'd like to see how other Runtime PM implementations deal with this.
So unless people object I prefer to keep it as-is for now.

/ magnus
