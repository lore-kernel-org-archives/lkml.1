Return-Path: <linux-kernel-owner+w=401wt.eu-S1754631AbYIBV6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631AbYIBV6p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 17:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752921AbYIBV6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 17:58:37 -0400
Received: from atlas.informatik.uni-freiburg.de ([132.230.150.3]:45832 "EHLO
	atlas.informatik.uni-freiburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752714AbYIBV6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 17:58:36 -0400
Date: Tue, 2 Sep 2008 23:05:02 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<ukleinek@informatik.uni-freiburg.de>
To: linux-kernel@vger.kernel.org
Subject: several wrong sections for probe functions of platform drivers
Message-ID: <20080902210501.GA4306@informatik.uni-freiburg.de>
Mail-Followup-To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <ukleinek@informatik.uni-freiburg.de>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="FL5UXtIhxfXey3p5"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
Organization: Universitaet Freiburg, Institut f. Informatik
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hello,

I wrote a small python script that extracts the section specifier for
probe functions of platform drivers and warns if it's != __devinit.
The script is attached.

It's not always an error if the probe function is defined using __init,
but then (AFAIK) it should not be passed in the struct platform_driver!?

With Linus' current tree (v2.6.27-rc5-55-gafa153f) I get 215 matches
with

	1x __devexit
	67x __init
	146x no section

and one match that isn't interpreted correctly by my script.

I think the __devexit case is definitly wrong.  I will do a deeper look
and then probably send a patch for that one as a follow up to this mail.

I didn't (yet) checked the other cases, but I expect that most of them
need fixing.

Would it make sense to start collecting such scripts in the vanilla
tree?

I appreciate any constructive feedback.

Best regards
Uwe

-- 
Uwe Kleine-König

If a lawyer and an IRS agent were both drowning, and you could only save
one of them, would you go to lunch or read the paper?

--FL5UXtIhxfXey3p5
Content-Type: text/x-python; charset=us-ascii
Content-Disposition: attachment; filename="probe_in_init.py"

#! /usr/bin/python

import os
import re

re_probename = re.compile('struct\s+platform_driver\s+(?P<drivername>\S+)\s*=\s*{.*\.probe\s*=\s*(?P<probefunction>[A-Za-z0-9_]*)', re.S)

for dirpath, dirnames, filenames in os.walk('.'):
    for f in filter(lambda s: s.endswith('.c'), filenames):
        fullf = os.path.join(dirpath, f)
        content = open(fullf).read()
        matchdict = dict(filename=fullf)

        mo = re_probename.search(content)
        if mo:
            matchdict.update(mo.groupdict())
        else:
            continue

        re_section = re.compile('int\s+(?:(?P<probesection>__(?:dev)?(?:init|exit)+)\s+)?%(probefunction)s\s*\(' % matchdict)
        mo = re_section.search(content)
        if mo:
            matchdict.update(mo.groupdict())
        else:
            matchdict['probesection'] = ''

        if matchdict['probesection'] != '__devinit':
            print 'probe function %(probefunction)r for %(drivername)r (%(filename)s) defined in section %(probesection)r' % matchdict

--FL5UXtIhxfXey3p5--
