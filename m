Return-Path: <linux-kernel-owner+w=401wt.eu-S1752001AbZKKGU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001AbZKKGU0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 01:20:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751618AbZKKGU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 01:20:26 -0500
Received: from casper.infradead.org ([85.118.1.10]:47888 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbZKKGUZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 01:20:25 -0500
Subject: Re: [PATCH 6/6] perf tools: Bring linear set of section headers
 for features
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
In-Reply-To: <1257911467-28276-6-git-send-email-fweisbec@gmail.com>
References: <1257911467-28276-1-git-send-email-fweisbec@gmail.com>
	 <1257911467-28276-6-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 11 Nov 2009 07:20:04 +0100
Message-ID: <1257920404.23203.0.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-11 at 04:51 +0100, Frederic Weisbecker wrote:
> Build a set of section headers for features right after the datas.
> Each implemented feature will have one of such section header that
> provides the offset and the size of the data manipulated by the feature.
> 
> The trace informations have moved after the data and are recorded
> on exit time.
> 
> The new layout is as follows:
> 
>  -----------------------
>                              ___
>  [ magic               ]      |
>  [ header size         ]      |
>  [ attr size           ]      |
>  [ attr content offset ]      |
>  [ attr content size   ]      |
>  [ data offset         ]  File Headers
>  [ data size           ]      |
>  [ event_types offset  ]      |
>  [ event_types size    ]      |
>  [ feature bitmap      ]      v 
> 
>  [ attr section        ]
>  [ events section      ]
> 
>                              ___
>  [         X           ]      |
>  [         X           ]      |
>  [         X           ]    Datas
>  [         X           ]      |
>  [         X           ]      v
> 
>                              ___
>  [ Feature 1 offset    ]      |
>  [ Feature 1 size      ] Features headers
>  [ Feature 2 offset    ]      |
>  [ Feature 2 size      ]      v
> 
>  [ Feature 1 content   ]
>  [ Feature 2 content   ]
>  -----------------------
> 
> We have as many feature's section headers as we have features in use for
> the current file.
> 
> Say Feat 1 and Feat 3 are used by the file, but not Feat 2. Then the
> feature headers will be like follows:
> 
> [ Feature 1 offset    ]      |
> [ Feature 1 size      ] Features headers
> [ Feature 3 offset    ]      |
> [ Feature 3 size      ]      v
> 
> There is no hole to cover Feature 2 that is not in use here. We only
> need to cover the needed headers in order, from the lowest feature bit
> to the highest.
> 
> Currently we have two features: HEADER_TRACE_INFO and HEADER_BUILD_ID.
> Both have their contents that follow the feature headers. Putting the
> contents right after the feature headers is not mandatory though.
> While we keep the feature headers right after the data and in order,
> their offsets can point everywhere. We have just put the two above
> feature contents in the end of the file for convenience.
> 
> The purpose of this layout change is to have a file format that scales
> while keeping it simple: having such linear feature headers is less
> error prone wrt forward/backward compatibility as the content of a
> feature can be put anywhere, its location can even change by the
> time, it's fine because its headers will tell where it is. And we know
> how to find these headers, following the above rules.

Does do mess up append though... be sure to add some magic for that.
