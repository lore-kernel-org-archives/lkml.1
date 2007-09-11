Return-Path: <linux-kernel-owner+w=401wt.eu-S932592AbXIKXsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932592AbXIKXsu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 19:48:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757697AbXIKXsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 19:48:42 -0400
Received: from mail.gmx.net ([213.165.64.20]:37063 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756286AbXIKXsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 19:48:42 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX1/J6lQRFwPJujIaww4WZk//JG2hOZP29DIbKBIjdD
	2zFzCaedguTpLs
Date: Wed, 12 Sep 2007 01:50:57 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Adrian McMenamin <lkmladrian@gmail.com>
Cc: Rene Herman <rene.herman@gmail.com>, linux-kernel@vger.kernel.org,
       linuxsh-dev@lists.sourceforge.net, Paul Mundt <lethal@linux-sh.org>
Subject: Re: time_after - what on earth???
Message-ID: <20070911235057.GA7348@atjola.homenet>
References: <8b67d60709111505u61771a1do74c82a55430ec214@mail.gmail.com> <46E7128D.1080006@gmail.com> <8b67d60709111515m5b45c57emef5cc2f74795ed7a@mail.gmail.com> <46E7145D.10907@gmail.com> <20070911230940.GA7070@atjola.homenet> <8b67d60709111610s41e1964dsc2fe21a6eca4096@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8b67d60709111610s41e1964dsc2fe21a6eca4096@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.09.12 00:10:19 +0100, Adrian McMenamin wrote:
> On 12/09/2007, Björn Steinbrink <B.Steinbrink@gmx.de> wrote:
> > On 2007.09.12 00:19:09 +0200, Rene Herman wrote:
> > > On 09/12/2007 12:15 AM, Adrian McMenamin wrote:
> > >
> > >> On 11/09/2007, Rene Herman <rene.herman@gmail.com> wrote:
> > >>> On 09/12/2007 12:05 AM, Adrian McMenamin wrote:
> > >>>
> > >>>> OK, why does this line occasionally return true:
> >
> > What exactly is "occassionally"?  Does it happen more than once per
> > boot? If not, and it happens after a certain time after booting, it
> > might be wrapping of the jiffie counter (see below).
> >
> > >>>>
> > >>>>       if ((maple_dev->interval > 0) && (jiffies >maple_dev->when))
> > >>>>
> > >>>> while this one never does (no other changes made):
> > >>>>
> > >>>> if  ((maple_dev->interval > 0) && (time_after(jiffies,
> > >>>> maple_dev->when)))
> > >>> Is maple_dev->when an unsigned long?
> > >>>
> > >> Yes. Does that make a difference?
> > >
> > > If it had been a signed type, it could've wrapped to something you didn't
> > > expect, explaining the difference at least...
> > >
> > > With an unsigned long, the only diference should be that time_after() deals
> > > with jiffie wrapping which I assume is not an actual problem here. I'll
> > > retreat into the shades again... ;-(
> >
> > If "occasionally" is limited to once per boot, it might be jiffie
> > wrapping. IIRC jiffies are initialized so that they wrap after about 5
> > minutes of uptime to reveal such bugs without forcing you to wait for
> > ages just to have the counter wrap for the first time.
> >
> 
> No, I mean "works properly" - ie occasionally evaluates as true

Ehrm, yeah, I somehow parsed that as if it had a negation in there.

Anyway, I looked up the patches you posted. "when" is initialized to 0
and only changed if the above condition evaluates to true. Now,
time_after and "<" have different points at which "future" and "past"
are separated. time_after splits (about) equally between future and
past, so 0 can be either, depending on the value of jiffies. But for "<"
0 is almost always in the past, except for the seldom event of jiffies
being 0.

Now, given that jiffies start out at a huge value to make the counter
wrap around early, 0 happens to be in the "future" for time_after, until
the wrap around occurs. So in your case, you just might have to wait
those 5 minutes to get the working behaviour, instead of the common case
in which it breaks after that time ;-)

A fix would likely initialize "when" to jiffies.

Björn
