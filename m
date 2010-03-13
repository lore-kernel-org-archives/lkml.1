Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934317Ab0CMJ4H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 04:56:07 -0500
Received: from mail-iw0-f176.google.com ([209.85.223.176]:50909 "EHLO
	mail-iw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480Ab0CMJ4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 04:56:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HT+N/ZFfmmetkZ2Tfs2eV/8LEcT5DnOt4Jz3b3Ez0R5uaaqgklBWP0sFDE2f0zV250
         WEy39gBlsSf5vbzLfObmkgE0eVG6yXVLc6S5iKDWovCIOUbt8F4bnFKk2UXXFSRETYhL
         XGx28MDptOmUyt+EckUZpHfGWibf9N68rrRLY=
Date: Sat, 13 Mar 2010 01:55:54 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Florian Mickler <florian@mickler.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       Marcel Holtmann <marcel@holtmann.org>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Johannes Berg <johannes@sipsolutions.net>,
       linux-wireless@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
       Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH 2/2] enhance sysfs rfkill interface
Message-ID: <20100313095554.GA16038@core.coreip.homeip.net>
References: <1268416988-24862-1-git-send-email-florian@mickler.org>
 <1268416988-24862-2-git-send-email-florian@mickler.org>
 <1268416988-24862-3-git-send-email-florian@mickler.org>
 <20100312182209.GB8736@core.coreip.homeip.net>
 <20100312215743.7671d173@schatten.dmk.lab>
 <20100312212025.GA17712@core.coreip.homeip.net>
 <20100312233925.74effc7d@schatten.dmk.lab>
 <20100312224828.GA18618@core.coreip.homeip.net>
 <20100313104128.79aa2846@schatten.dmk.lab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100313104128.79aa2846@schatten.dmk.lab>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 13, 2010 at 10:41:28AM +0100, Florian Mickler wrote:
> On Fri, 12 Mar 2010 14:48:28 -0800
> Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> 
> > On Fri, Mar 12, 2010 at 11:39:25PM +0100, Florian Mickler wrote:
> > > On Fri, 12 Mar 2010 13:20:26 -0800
> > > Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> > > 
> > > > On Fri, Mar 12, 2010 at 09:57:43PM +0100, Florian Mickler wrote:
> > > > > On Fri, 12 Mar 2010 10:22:09 -0800
> > > > > Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> > > > > 
> > > > > > On Fri, Mar 12, 2010 at 07:03:08PM +0100, florian@mickler.org wrote:
> > > > > > >  
> > > > > > > +static ssize_t rfkill_hard_show(struct device *dev,
> > > > > > > +				 struct device_attribute *attr,
> > > > > > > +				 char *buf)
> > > > > > > +{
> > > > > > > +	struct rfkill *rfkill = to_rfkill(dev);
> > > > > > > +	unsigned long flags;
> > > > > > > +	u32 state;
> > > > > > > +
> > > > > > > +	spin_lock_irqsave(&rfkill->lock, flags);
> > > > > > > +	state = rfkill->state;
> > > > > > > +	spin_unlock_irqrestore(&rfkill->lock, flags);
> > > > > > 
> > > > > > Why exactly is this lock needed?
> > > > > 
> > > > > The rfkill state is updated from multiple contexts... Am I overlooking
> > > > > smth obvious here?
> > > > > 
> > > > 
> > > > You are not updating but reading... Are you concerned about seeing
> > > > a partial write to u32? It does not happen.
> > > > 
> > > Hm.. You shure? On every arch that supports wireless drivers? 
> > > 
> > > I've just copied that code from the old sysfs state-file handler.
> > > So I assumed that reading partial updated state can happen... Also I
> > > just searched a little but did not find anything, cause i didn't know
> > > where to look. Who garantees this? Is it a gcc thing? 
> > > 
> > 
> > None of the arches would do byte-by-byte writes to a u32, they'd write
> > dword at once. Also, even if they could, you are interested in a single
> > flag (bit). You do realize that once you leave spinlock whatever you
> > fetched is stale data and may not be trusted?
> 
> On Fri, 12 Mar 2010 18:48:19 -0500
> Valdis.Kletnieks@vt.edu wrote:
> > If a u32 load or store from memory isn't atomic, the Linux kernel is screwed
> > anyhow.  Hint - imagine if every 32-bit reference had to be treated the way
> > we currently treat 64-bit references on a 32-bit system.
> 
> 
> i presume, there is no way any digital device could write _one bit_
> partial :) 
> so this _may_ actually be safe *g* 
>  
> how about the write in the _store() function? there we
> read,update and write back the whole 32 bit which then potentially
> overwrites some other flag concurrently set by an driver interrupt on
> another cpu? i think the lock there is needed.
>

Well, right now it is mutex so it will not protect if something happens
in interrupt context. Takeing the global rfkill mutex seems pretty heavy
but there does not seem to be a per-device mutex. There also some
muching with spinlock inside rfkill_set_state but it is dropped when we
actually carry out the operation. I am afraid the locking in rfkill
needs some reviewing...

-- 
Dmitry
