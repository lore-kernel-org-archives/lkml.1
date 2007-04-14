Return-Path: <linux-kernel-owner+w=401wt.eu-S965407AbXDNIPF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965407AbXDNIPF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 04:15:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753570AbXDNIPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 04:15:04 -0400
Received: from smtp112.plus.mail.re2.yahoo.com ([206.190.53.37]:45225 "HELO
	smtp112.plus.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753248AbXDNIPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 04:15:01 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=USSEXKHYqAAZy+QSGSVfUYe3TJFDD2KcPIhamx43lA4z8OChQq5VcDcIxd9Aiaja8K5aKOdoKzSyOGDpRlA2t6Rwop0n/qO2BwUh7BDJaKY794GkYSloLGAfB6StnUYeOUdRN5F52XUB5P3RhcXmy9ZPb+e2zt4h2XCbi+EGqmo=  ;
X-YMail-OSG: dIipKEAVM1lHcRa_dztf1GJ..qd6xckDoushob.3lnvBEn6nxwFdwBnKbIzJ3S1q7RyOQpTIPvzkQSo_SJ_iOL0RMFkmI8GSZ9NXahOu13lYMN5K1ZnG
Date: Sat, 14 Apr 2007 10:14:50 +0200
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [KERNEL-DOC] fix tex error when building pdfdocs
Message-ID: <20070414081450.GA4160@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
References: <20070412203842.GA14245@zmei.tnic> <20070412164851.0c5d6e54.randy.dunlap@oracle.com> <20070413063459.GA4075@gollum.tnic> <20070413082049.adbc611d.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070413082049.adbc611d.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2007 at 08:20:49AM -0700, Randy Dunlap wrote:
> On Fri, 13 Apr 2007 08:35:00 +0200 Borislav Petkov wrote:
> 
> > On Thu, Apr 12, 2007 at 04:48:51PM -0700, Randy Dunlap wrote:
> > > On Thu, 12 Apr 2007 22:38:42 +0200 Borislav Petkov wrote:
> > > 
> > > > When building pdfdocs, the db2pdf converter bails out because of an
> > > > latex-reserved token  - '#' - in the intermediary .tex file which ends up in a
> > > > conversion error with the following error message: 
> > > > 
> > > > <log>
> > > > [15.0.32])
> > > > ! Incomplete \iffalse; all text was ignored after line 8154.
> > > > <inserted text>
> > > >                 \fi
> > > > <*> kernel-hacking.tex
> > > > </log>
> > > > 
> > > > This is a rather arbitrary fix, so suggest away.
> > > 
> > > Hi,
> > > 
> > > I don't have a problem with the change, but I don't get that tex error either.
> > > Here is an extract from the .tex file:
> > > 
> > > 
> > > {\def\Element%
> > > {451}\def\ProcessingMode%
> > > {title-sosofo-mode}}\#if\endNode{}\endSeq{}\endLink{}\Seq%
> > > {}\Leader%
> > > {}.\endLeader{}\Link%
> > >
> > <snip>
> > 
> > Actually this is the TOC-piece of .tex code around line 1622. The offending line
> > is way down (ca. 8152) at the actual chapter heading and it looks like this:
> > 
> > {\def\Element%
> > {0:451}\def\ProcessingMode%
> > {title-sosofo-mode}}\#if\endNode{}\def\HeadingText{%
> > 10.7. \if}%
> > \endHeadPar{}\endSeq{}\Node%
> > 
> > and I think it is the fourth line that causes the problem for the # sign is
> > stripped and the title is converted to a tex conditional - \if - which isn't
> > terminated, but I'm not so sure. The thing is, the docbook2tex converts the
> > .tmpl file to .tex file ok but db2pdf chokes. What docbook-utils are you using?
> > Mine are version 0.6.14-1 of debian unstable.
> 
> I'm using:  docbook-utils-0.6.14-79  (SLED 10)
> 
> and the corrected :) lines contain an additional '#':
> 
> {1}}10.7. \Node%
> {\def\Element%
> {451}\def\ProcessingMode%
> {title-sosofo-mode}}\#if\endNode{}\def\HeadingText{%
> 10.7. \#if}%
> \endHeadPar{}\endSeq{}\Node%
> {\def\Element%
> {451}}\endNode{}\Node%

I got it, the problem is in that we use different DSSSL engines. Mine was
openjade, therefore the different section numbers like {0:451} vs. jade's {451},
i.e. without the leading zero. I switched to jade and kernel-hacking.tex converts fine.
The thereby generated tex code looks also differently:

{\def\Element%
{451}\def\ProcessingMode%
{title-sosofo-mode}}\#if\endNode{}\endPar{}\endSeq{}\Node%
{\def\Element%
{451}}\endNode{}\Node%

-- 
Regards/Gruﬂ,
    Boris.
