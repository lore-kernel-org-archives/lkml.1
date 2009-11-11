Return-Path: <linux-kernel-owner+w=401wt.eu-S1758160AbZKKQw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758160AbZKKQw2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 11:52:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758031AbZKKQw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 11:52:26 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:60630 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757510AbZKKQtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 11:49:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sSljoOPX7NLaN/IVaDbMG8uxXmJNA7RzpYDaP2M8jU21PeHluKSQPQDiMn0qcWOn7b
         9EQ//pcc00geE3FHbh8B+0uSzyUKePIZ1f/nDdbkHNMI3D9v7wWdS5H01AmscAwYoiOp
         ZX6/6jpQ0ri7iP+8qGSSCQB7nCSaxVPjZ4AHg=
Date: Wed, 11 Nov 2009 17:49:37 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Subject: Re: [PATCH 6/6] perf tools: Bring linear set of section headers
	for features
Message-ID: <20091111164933.GB5255@nowhere>
References: <1257911467-28276-1-git-send-email-fweisbec@gmail.com> <1257911467-28276-6-git-send-email-fweisbec@gmail.com> <1257920404.23203.0.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257920404.23203.0.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 11, 2009 at 07:20:04AM +0100, Peter Zijlstra wrote:
> On Wed, 2009-11-11 at 04:51 +0100, Frederic Weisbecker wrote:
> > Build a set of section headers for features right after the datas.
> > Each implemented feature will have one of such section header that
> > provides the offset and the size of the data manipulated by the feature.
> > 
> > The trace informations have moved after the data and are recorded
> > on exit time.
> > 
> > The new layout is as follows:
> > 
> >  -----------------------
> >                              ___
> >  [ magic               ]      |
> >  [ header size         ]      |
> >  [ attr size           ]      |
> >  [ attr content offset ]      |
> >  [ attr content size   ]      |
> >  [ data offset         ]  File Headers
> >  [ data size           ]      |
> >  [ event_types offset  ]      |
> >  [ event_types size    ]      |
> >  [ feature bitmap      ]      v 
> > 
> >  [ attr section        ]
> >  [ events section      ]
> > 
> >                              ___
> >  [         X           ]      |
> >  [         X           ]      |
> >  [         X           ]    Datas
> >  [         X           ]      |
> >  [         X           ]      v
> > 
> >                              ___
> >  [ Feature 1 offset    ]      |
> >  [ Feature 1 size      ] Features headers
> >  [ Feature 2 offset    ]      |
> >  [ Feature 2 size      ]      v
> > 
> >  [ Feature 1 content   ]
> >  [ Feature 2 content   ]
> >  -----------------------
> > 
> > We have as many feature's section headers as we have features in use for
> > the current file.
> > 
> > Say Feat 1 and Feat 3 are used by the file, but not Feat 2. Then the
> > feature headers will be like follows:
> > 
> > [ Feature 1 offset    ]      |
> > [ Feature 1 size      ] Features headers
> > [ Feature 3 offset    ]      |
> > [ Feature 3 size      ]      v
> > 
> > There is no hole to cover Feature 2 that is not in use here. We only
> > need to cover the needed headers in order, from the lowest feature bit
> > to the highest.
> > 
> > Currently we have two features: HEADER_TRACE_INFO and HEADER_BUILD_ID.
> > Both have their contents that follow the feature headers. Putting the
> > contents right after the feature headers is not mandatory though.
> > While we keep the feature headers right after the data and in order,
> > their offsets can point everywhere. We have just put the two above
> > feature contents in the end of the file for convenience.
> > 
> > The purpose of this layout change is to have a file format that scales
> > while keeping it simple: having such linear feature headers is less
> > error prone wrt forward/backward compatibility as the content of a
> > feature can be put anywhere, its location can even change by the
> > time, it's fine because its headers will tell where it is. And we know
> > how to find these headers, following the above rules.
> 
> Does do mess up append though... be sure to add some magic for that.


Yep. It seems to work. What happens is that trace information are
re-computed. The same goes for build id I guess.

What happens is that the appended datas override the features sections
and headers, but this is fine because we rewrite them in the end.

But these both need to support appending mode internally (ie: append
the new informtions on top of exisiting ones instead of redo the whole)
and then rewrite the whole at exit like it's done currently.

