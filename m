Return-Path: <linux-kernel-owner+w=401wt.eu-S1755473AbZJSIEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473AbZJSIEP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 04:04:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753154AbZJSIEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 04:04:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40142 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753125AbZJSIEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 04:04:13 -0400
Date: Mon, 19 Oct 2009 10:04:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Arjan van de Ven <arjan@infradead.org>,
       David Miller <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: nfs mount fail
Message-ID: <20091019080403.GA24036@elte.hu>
References: <84144f020910181935q4aed9f0dx7a8a149d8b8743c7@mail.gmail.com> <20091019114339.4b67d947@infradead.org> <1255921080.839.2.camel@penberg-laptop> <86802c440910182252v4648a7d1k249d091799583e37@mail.gmail.com> <1255933848.11116.2.camel@heimdal.trondhjem.org> <20091019065433.GA29550@elte.hu> <1255935518.18914.0.camel@penberg-laptop> <20091019070825.GA16493@elte.hu> <86802c440910190031m33e116d3o90869de5212bb2e@mail.gmail.com> <1255938774.11116.35.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255938774.11116.35.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Trond Myklebust <trond.myklebust@fys.uio.no> wrote:

> > --- a/fs/nfs/super.c
> > +++ b/fs/nfs/super.c
> > @@ -1253,6 +1253,7 @@ static int nfs_parse_mount_options(char *raw,
> >  			default:
> >  				dfprintk(MOUNT, "NFS:   unrecognized "
> >  						"transport protocol\n");
> > +				kfree(string);
> >  				return 0;
> >  			}
> >  			break;
> 
> There is a possible clean up there too. We can move the other kfree() 
> calls out of the inner switch statement, and coalesce them all into a 
> single call.

Correct - separately from the leak fix. (which potentially wants to go 
to -stable as well)

Plus it's not just the kfree() calls that can be refactored but also the 
~25 match_strdup() call sites. Most of these repetitive sequences:

                case Opt_retrans:
                        string = match_strdup(args);
                        if (string == NULL)
                                goto out_nomem;
                        rc = strict_strtoul(string, 10, &option);
                        kfree(string);
                        if (rc != 0 || option == 0)
                                goto out_invalid_value;
                        mnt->retrans = option;
                        break;

could be pushed into a helper function, along the lines of:

                case Opt_retrans:
			if (parse_opt(args, &mnt->retrans) < 0 || mnt->retrans == 0)
                                goto out_invalid_value;
                        break;

where the non-repetitive value checks can be done after a generic 
parse_opt(). (or something like that)

That makes it more readable as well, as the switch statement will only 
list true per option properties, with minimal repetitive patterns.

	Ingo
