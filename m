Return-Path: <linux-kernel-owner+w=401wt.eu-S1755903AbYA2KoN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903AbYA2KoN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 05:44:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753619AbYA2Kn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 05:43:57 -0500
Received: from hobbit.corpit.ru ([81.13.94.6]:22991 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753835AbYA2Knz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 05:43:55 -0500
Message-ID: <479F0369.3080309@msgid.tls.msk.ru>
Date: Tue, 29 Jan 2008 13:43:53 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Icedove 1.5.0.12 (X11/20070607)
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@vyatta.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Udev coldplugging loads 8139too driver instead of 8139cp
References: <1201554992.13883.13.camel@Anastacia>	<479E7750.9060304@msgid.tls.msk.ru> <20080128170830.6f67fa5a@deepthought>
In-Reply-To: <20080128170830.6f67fa5a@deepthought>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger wrote:
> On Tue, 29 Jan 2008 03:46:08 +0300
> Michael Tokarev <mjt@tls.msk.ru> wrote:
[]
>> There are 2 drivers for 8139-based NICs.  For really different two kinds
>> of hardware, which both uses the same PCI identifiers.  Both drivers
>> "claims" to work with all NICs with those PCI ids, because "externally"
>> (by means of udev for example) it's impossible to distinguish the two
>> kinds of hardware, it becomes clean only when the driver (either of the
>> two) loads and actually checks which hardware we have here.
> 
> Is there any chance of using subdevice or subversion to tell them apart?
> That worked for other vendors like DLINK who slapped same ID on different
> cards.

If it were that simple... ;)

No.  The difference is in PCI revision number (byte #8 in PCI config space).
If it's >= 0x40 - it's 8139too, < 0x40 - 8139cp.  Or 0x20 - I forgot.

Here's a code snippet from a shell script I used ages ago to automatically
load modules (similar to what udev does nowadays):

  # special hack for 8139{too,cp} stuff
  case "$modalias" in
  *v000010ECd00008139*)
    rev="$(dd if="$1/config" bs=1 skip=8 count=1 2>/dev/null)"
    if [ -n "$rev" ]; then
      list=
      for module in $modlist; do
        case "$module" in
        8139cp)
          if [ ".$rev" \< ". " ]; then
            $vecho1 "$TAG: not loading $module for this device"
            continue
          fi
          ;;
        8139too)
          if [ ".$rev" \> ". " ]; then
            $vecho1 "$TAG: not loading $module for this device"
            continue
          fi
          ;;
        esac
        list="$list $module"
      done
      modlist="$list"
    fi
    ;;
  esac

/mjt
