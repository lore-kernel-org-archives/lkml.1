Return-Path: <linux-kernel-owner+w=401wt.eu-S1762877AbZJOPvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762877AbZJOPvl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 11:51:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762859AbZJOPvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 11:51:40 -0400
Received: from cpsmtpm-eml102.kpnxchange.com ([195.121.3.6]:57439 "EHLO
	CPSMTPM-EML102.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762858AbZJOPvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 11:51:39 -0400
From: Frans Pop <elendil@planet.nl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: Linux 2.6.32-rc3
Date: Thu, 15 Oct 2009 17:51:01 +0200
User-Agent: KMail/1.9.9
Cc: torvalds@linux-foundation.org, hohndel@infradead.org, lenb@kernel.org,
       linux-kernel@vger.kernel.org
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <alpine.LFD.2.00.0910052140100.309@localhost.localdomain> <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com> <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain> <20091006144449.GA23078@elte.hu> <alpine.LFD.2.01.0910060815320.3432@localhost.localdomain> <alpine.LFD.2.01.0910060815320.3432@localhost.localdomain> <20091006153632.GA29795@elte.hu>
In-reply-To: <20091006153632.GA29795@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910151751.02622.elendil@planet.nl>
X-OriginalArrivalTime: 15 Oct 2009 15:51:03.0388 (UTC) FILETIME=[4CA381C0:01CA4DAF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> hm, i think you ignored (or missed, or found irrelevant) my first
> suggested variant:
> 
> v2.6.31
> v2.6.31+

A general concern about adding the "+".

Anyone want to bet how many (init?) scripts there are in userspace that do 
something like:

KVERS="$(uname -r | cut -d"-" -f1)"
case $KVERS in
  2.6.*)
    minor=$(echo $KVERS | cut -d"." -f3)
    if [ $minor -lt 10 ]; then
      # do something
    fi ;;
esac

Note that the '[ $minor -lt 10 ]' will now produce an error because
'31+' is no longer a valid number:
   bash: [: 31+: integer expression expected

A "-" has for ages been the standard separator between the kernel version 
and any suffixes, certainly in Debian. Loads of scripts will assume that.

In an earlier mail I said that I would consider using the "+". This is 
seriously making me have second thoughts, even for custom built kernels.


Here are some real life examples from my Debian stable system:
/etc/init.d/pcmciautils:
supported_kernel()
{
    case $KERNEL_VERSION in
        2.[012345].*|2.6.[0-9]|2.6.[0-9][!0-9]*) return 1 ;;
        2.6.1[012]|2.6.1[012][!0-9]*) return 1 ;;
    esac
    return 0
}

Would have failed for e.g. a 2.6.12+ kernel.

/etc/init.d/umountnfs.sh:
KERNEL="$(uname -s)"
RELEASE="$(uname -r)"
case "${KERNEL}:${RELEASE}" in
  Linux:[01].*|Linux:2.[01].*)
        FLAGS=""
        ;;
  Linux:2.[23].*|Linux:2.4.?|Linux:2.4.?-*|Linux:2.4.10|Linux:2.4.10-*)
        FLAGS="-f"
        ;;
  *)
        FLAGS="-f -l"
        ;;
esac

Would have failed for e.g. a 2.4.7+ kernel.

Sure, these won't fail if we start adding the "+" now, but will the people 
writing such tests in the future always remember to allow for the "+", 
especially given that it will be relatively rare in a distro context?

Cheers,
FJP
