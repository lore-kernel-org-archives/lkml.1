Return-Path: <linux-kernel-owner+w=401wt.eu-S934511AbXHYWqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934511AbXHYWqt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 18:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753723AbXHYWqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 18:46:39 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:2534 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbXHYWqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 18:46:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VChMF6aRpTykr5PDEcBEb5l+BuBHDRuClHWx1p6nBaRS0fgz+QsHmeuFLJK6qsTqH73OFEJkoz1Cnxe21YZwixLUOn+KeUKyda7QqTDWWhR6oNXxmIxan2aSU76byK6ckYA7KAxq6t9Gk9ojleN3Lg8E3Kf88S23+fgkuv0NBAA=
Message-ID: <9d732d950708251546t6a441c4pd3ce78c46ce27617@mail.gmail.com>
Date: Sun, 26 Aug 2007 07:46:37 +0900
From: "Toshiharu Harada" <haradats@gmail.com>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: [TOMOYO 14/15] Conditional permission support.
Cc: "Kentaro Takeda" <k.takeda26@gmail.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, chrisw@sous-sol.org
In-Reply-To: <20070825110825.GB5850@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46CED214.6050505@gmail.com> <46CED5C6.8050501@gmail.com>
	 <20070825110825.GB5850@ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2007/8/25, Pavel Machek <pavel@ucw.cz>:
> Hi!
>
> > This patch allows administrators use conditional permission.
> > TOMOYO Linux supports conditional permission based on
> > process's UID,GID etc. and/or requested pathname's UID/GID.
> >
> > Signed-off-by: Kentaro Takeda <takedakn@nttdata.co.jp>
> > Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
>
> > + * Since the trailing spaces are removed by tmy_normalize_line(),
> > + * the last "\040if\040" sequence corresponds to condition part.
> > + */
> > +char *tmy_find_condition_part(char *data)
> > +{
> > +     char *cp = strstr(data, " if ");
> > +     if (cp) {
> > +             char *cp2;
> > +             while ((cp2 = strstr(cp + 3, " if ")) != NULL)
> > +                     cp = cp2;
> > +             *cp++ = '\0';
> > +     }
> > +     return cp;
> > +}
> ...
>
> > +     unsigned long left_min = 0;
> > +     unsigned long left_max = 0;
> > +     unsigned long right_min = 0;
> > +     unsigned long right_max = 0;
> > +     if (strncmp(condition, "if ", 3))
> > +             return NULL;
> > +     condition += 3;
> > +     start = condition;
> > +     while (*condition) {
> > +             if (*condition == ' ')
> > +                     condition++;
> > +             for (left = 0; left < MAX_KEYWORD; left++) {
> > +                     if (strncmp(condition, cc_keyword[left].keyword,
> > +                                 cc_keyword[left].keyword_len))
> > +                             continue;
> > +                     condition += cc_keyword[left].keyword_len;
> > +                     break;
> > +             }
> > +             if (left == MAX_KEYWORD) {
> > +                     if (!tmy_parse_ulong(&left_min, &condition))
> > +                             goto out;
> > +                     counter++; /* body */
> > +                     if (*condition != '-')
> > +                             goto not_range1;
> > +                     condition++;
> > +                     if (!tmy_parse_ulong(&left_max, &condition)
> > +                         || left_min > left_max)
> > +                             goto out;
> > +                     counter++; /* body */
> > +not_range1: ;
> > +             }
> > +             if (strncmp(condition, "!=", 2) == 0)
> > +                     condition += 2;
> > +             else if (*condition == '=')
> > +                     condition++;
> > +             else
> > +                     goto out;
> > +             counter++; /* header */
> > +             for (right = 0; right < MAX_KEYWORD; right++) {
> > +                     if (strncmp(condition, cc_keyword[right].keyword,
> > +                                 cc_keyword[right].keyword_len))
> > +                             continue;
> > +                     condition += cc_keyword[right].keyword_len;
> > +                     break;
> > +             }
>
> What is that? Language parser in kernel?
>
>                                                         Pavel

Key idea of TOMOYO Linux is to let each process to remember the program
(path) name. Names are stored in task struct and "appended" to the list when
execve is called.

An example of /usr/lib/cups/backend/lpd.
(picked up from
http://tomoyo.sourceforge.jp/cgi-bin/lxr/source/centos4.4/domain_policy.txt?v=policy-sample)

/etc/rc.d/init.d/cups (fork&exec)
 /sbin/initlog (fork&exec)
   /usr/sbin/cupsd (fork&exec)
     /bin/bash (fork&exec)
       /usr/lib/cups/backend/lpd (current process)

SELinux and other DTE implementations need domain definitions to  work.
It is administrators task to design domains and name each domains.
TOMOYO Linux can be used as DTE MAC, but administrators don't
have to define and name domains. Because TOMOYO Linux
automatically defines domains and name them (from booting to
shutdown).

I wrote "TOMOYO Linux can be used as MAC", because
users can just view the domain transitions and analyze systems
with TOMOYO Linux. Or they can use TOMOYO Linux to
get logs with process invocation histories instead of a simple
program name.

TOMOYO Linux policy consists of path names and they are currently
handled as strings.

Thanks.

--
Toshiharu Harada
NTT DATA CORPORATION
