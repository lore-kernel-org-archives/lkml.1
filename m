Return-Path: <linux-kernel-owner+w=401wt.eu-S1754879AbYKZIvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879AbYKZIvQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 03:51:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754354AbYKZIoz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 03:44:55 -0500
Received: from wf-out-1314.google.com ([209.85.200.174]:40976 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754612AbYKZIox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 03:44:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=J+A4iW2imuzP6yt08z6sr1BBM9Q1hkNhOqvHUfdpPJmhXTpmRDvN7szTCf+SpQlo6y
         O1Jc4JSuFjE7woaztfg3/F6HdPwUetCNy4bjiMmPxkERDVkbJlVtp9ewuqzzco5sXTYx
         dk0TubgD2rgCckI9ecVLx0LLJETX1E4TPZWIo=
Subject: Re: [PATCH 2/5] ftrace: use code patching for ftrace graph tracer
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       containers@lists.osdl.org,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <20081126003553.12d38150.akpm@linux-foundation.org>
References: <20081126051622.134970943@goodmis.org>
	 <20081126051709.774546196@goodmis.org>
	 <20081125213546.ff4eddf4.akpm@linux-foundation.org>
	 <1227682349.5511.47.camel@brick>
	 <20081126000430.5c19e189.akpm@linux-foundation.org>
	 <1227688024.5511.56.camel@brick>
	 <20081126003553.12d38150.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 26 Nov 2008 00:44:48 -0800
Message-Id: <1227689088.5511.62.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-11-26 at 00:35 -0800, Andrew Morton wrote:
> On Wed, 26 Nov 2008 00:27:04 -0800 Harvey Harrison <harvey.harrison@gmail.com> wrote:
> 
> > if (code[0] != 0xe9 || old_offset != load32_noalign(&code[1]))
> > 
> > This is similar to the new API in -mm load_le32_noalign, but I
> > don't think it would be worth load_u32_noalign...load32 should
> > be enough.
> > 
> > > > > > +		return -EINVAL;
> > > > > > +
> > > > > > +	*(int *)(&code[1]) = new_offset;
> > > > > 
> > > > > Might be able to use put_unaligned_foo() here.
> > > > > 
> > > > 
> > > > 	put_unaligned(new_offset, (int *)(&code[1]));
> > > > 
> > 
> > In a similar vein to above, this becomes:
> > 
> > 	store32_noalign(&code[1], new_offset);
> > 
> 
> yes, that's much better than the party tricks with magical sizeof,
> which forces you to run around and check the types of everything.
> 
> I've seen people doing get_user() on `long' types and such things
> occasionally.
> 

Do you want to carry the patches to move to the new helpers until they
hit mainline, or would you rather I waited until they can go through
maintainer trees?

I've got the pile ready removing all of the get/put_{endian} and moving
to the load/store API.  Not much left after that to just remove the
magical sizeof versions too.  Just let me know what timing you'd prefer.

Also, all of this ends up being so intertwined in the aligned/unaligned
cases that I'd like to move most of Documentation/unaligned_memory_access.txt
into a new alignment_and_byteorder.txt to cover all of these new helpers.

I started most of a byteorder document, but constantly referring to the other
file made it a bit tiresome, would you mind a consolidated document?

Harvey

