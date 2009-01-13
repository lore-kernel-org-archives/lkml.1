Return-Path: <linux-kernel-owner+w=401wt.eu-S1757508AbZAMWic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508AbZAMWic (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 17:38:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755114AbZAMWiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 17:38:22 -0500
Received: from fk-out-0910.google.com ([209.85.128.184]:25008 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbZAMWiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 17:38:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=gfszGMZv5qqOe1XLTJyD5YbpGBEKNZBBw7niGitmzNXIRzy0jaVIQhp7LkqLpLG/lj
         jc/PgmiHd0pzl4OHQcyxlgAySLHCyc3fmOvVnuaJZHpPD8vagzYQuwlRWaS1q7pGZ6MZ
         px7+UA/fivyifYkZAzEqg+xZHV7D6H8tufiNQ=
Message-ID: <cfd18e0f0901131438n232ba114n27ea2d7964d071de@mail.gmail.com>
Date: Wed, 14 Jan 2009 11:38:18 +1300
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Reply-To: mtk.manpages@gmail.com
To: "Roland McGrath" <roland@redhat.com>
Subject: waitid() return value strangeness when infop is NULL
Cc: "kernel list" <linux-kernel@vger.kernel.org>,
       "Ulrich Drepper" <drepper@redhat.com>,
       "Vegard Nossum" <vegard.nossum@gmail.com>,
       "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>
In-Reply-To: <cfd18e0f0901131436ud2cf61bkf0e6b00f4b765bb5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cfd18e0f0901131436ud2cf61bkf0e6b00f4b765bb5@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Resend with right LKML address.]

Hello Roland,

Vegard sent me a report of a possible bug in the waitid(2) man page,
but on closer examination, the issue seems to be in the waitid()
system call.

POSIX.1 says of waitid():

  RETURN VALUE
      If WNOHANG was specified and there are no children to wait for,
      0 shall be returned. If waitid() returns due to the  change  of
      state  of  one of its children, 0 shall be returned. Otherwise,
      -1 shall be returned and errno set to indicate the error.

The Linux waitid() follows this behavior, as long as infop is not
NULL, which is what POSIX requires:

      The  application shall ensure that the infop argument points to
      a siginfo_t structure.

However, Linux's waitid() does permit infop to be NULL.  But in this
case, a successful call returns the PID of the waited-for child.
Thinking about it, I suppose there is a rationale for doing this,
since otherwise the caller of waitid() has no way of obtaining the PID
of the waited-for child.  Anyway, this behavior should either be
documented, or "fixed" (i.e., change waitid() to return 0 on success
even if infop is NULL).  So, some questions:

a) Is it intentional to support the infop==NULL case for waitid() --
rather than simply giving an error return?

b) If so, what is the rationale for supporting this feature?

c) If the the answer a) is "yes", is it intentional for
waitid(idtype,id,NULL,options) to return the PID of the child, rather
than returning 0?

I'll post a test program in a follow-up message.

Cheers,

Michael



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
