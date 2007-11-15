Return-Path: <linux-kernel-owner+w=401wt.eu-S1765211AbXKOU3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765211AbXKOU3s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 15:29:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755167AbXKOU3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 15:29:38 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:13687 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbXKOU3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 15:29:37 -0500
X-Greylist: delayed 460 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Nov 2007 15:29:37 EST
Date: Thu, 15 Nov 2007 13:20:43 -0700
From: Alex Chiang <achiang@hp.com>
To: Greg KH <greg@kroah.com>, Matt_Domsch@dell.com
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, linux-pci@atrey.karlin.mff.cuni.cz,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>, gregkh@suse.de,
       lenb@kernel.org, matthew@wil.cx, rick.jones2@hp.com,
       linux-kernel@vger.kernel.org, pcihpd-discuss@lists.sourceforge.net,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/5][RFC] Physical PCI slot objects
Message-ID: <20071115202043.GB25052@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Greg KH <greg@kroah.com>, Matt_Domsch@dell.com,
	Bjorn Helgaas <bjorn.helgaas@hp.com>,
	linux-pci@atrey.karlin.mff.cuni.cz,
	Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
	gregkh@suse.de, lenb@kernel.org, matthew@wil.cx, rick.jones2@hp.com,
	linux-kernel@vger.kernel.org, pcihpd-discuss@lists.sourceforge.net,
	linux-acpi@vger.kernel.org
References: <20071113000853.GA13341@ldl.fc.hp.com> <20071113202632.GA3227@kroah.com> <20071113145936.7e1c58fb.kristen.c.accardi@intel.com> <200711141037.09228.bjorn.helgaas@hp.com> <20071114175317.GB14994@kroah.com> <20071114214221.GC6575@ldl.fc.hp.com> <20071114220022.GB19850@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071114220022.GB19850@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg, Matt,

* Greg KH <greg@kroah.com>:
> On Wed, Nov 14, 2007 at 02:42:21PM -0700, Alex Chiang wrote:
> > * Greg KH <greg@kroah.com>:
> > > On Wed, Nov 14, 2007 at 10:37:08AM -0700, Bjorn Helgaas wrote:
> > > > 
> > > > So I agree that the firmware kit has a clever hack that works
> > > > on much existing x86 firmware, and it sounds like Tivoli
> > > > might even rely on it.  But I don't feel good about it, and
> > > > it could easily break when some BIOS writer needs to make
> > > > _SUN slightly more complicated.
> > > 
> > > Do you know of such BIOSes out there that do this?  Will the
> > > above scheme not work for the ia64 boxes that you know of that
> > > are out in the world today?
> > 
> > One last mail on this subject -- Bjorn has pointed out to me that
> > the Dell pe6800 and rez1850 both implement _SUN as control
> > methods today.
> 
> Does the firmware kit break on them?

I downloaded the firmware kit today and played with it. There is
a test called SUN.exe, which searches through the DSDT, looking
to verify that there are no duplicate _SUN values in the system.

The test breaks on my hp rx6600 (a currently shipping platform),
because _SUN is not a hard-coded value, but implemented as an AML
control method. From the various SSDT dumps:

Here's the _SUN for a slot:
	Method (_SUN, 0, Serialized)
	{
		Store (\SLOT.SUN, ^_UID)
		Local0
		Return (Local0)
	}

Here's the _SUN for a processor:
	Method (_SUN, 0, NotSerialized)
	{
		Store (\CPUL.SUN, ^CPID)
		Local0
		Return (Local0)
	}

So parse_SUN_name() from SUN.c is just plain broken. The test
"passes" because it doesn't find any duplicate values for _SUN,
but what's really going on is that it doesn't find *any* values
of _SUN, so of course there won't be duplicates. ;)

I looked at convincing this test to try and execute the method
using ExecuteAmlMethod() and/or execute_aml_method(), but of
course, that won't work on a modern kernel, as they depend on
/proc/acpi/hotkey/, which was removed (as Bjorn pointed out).

Matt, is there any chance you could see if the firmware kit works
or breaks on your PE6800? 

I downloaded the latest tarball:

  http://www.linuxfirmwarekit.org/download/firmwarekit-r3.tar.gz

And ran it in stand-alone mode. You do need to build the test
suite, but you don't need to run the entire thing -- just run the
SUN/SUN.exe that is generated. (If you get odd complaints about
not being able to find libstandalone.so, just stick it in
/usr/local/lib, modify /etc/ld.so.conf as necessary and run
ldconfig).

Please apply the following debug patch to see how many _SUN
objects the test is actually finding. On my machine, I don't find
any _SUN objects.

Thanks.

/ac

diff --git a/SUN/SUN.c b/SUN/SUN.c
index 90264a7..3b21b9c 100644
--- a/SUN/SUN.c
+++ b/SUN/SUN.c
@@ -260,6 +260,7 @@ static void parse_SUN_name(gpointer data, gpointer user_data)
 int main(int argc, char **argv)
 {
 
+	int i;
 	start_test("SUN", "SUN duplicate test", 
 	"This makes sure that each SUN (Slot Unique Number) that is "
 	"called in the DSDT through the Name() method is unique, no "
@@ -281,6 +282,11 @@ int main(int argc, char **argv)
 		
 	/* List SUN duplicates (if any) */
 	do_SUN_check();
+
+ 	while(SUN_list[i].line_num) { 
+		printf("## found SUN: %s\n", SUN_list[i].SUN_hexnum);
+		i++;
+	}
 	
 	finish_test("SUN");
 	return EXIT_SUCCESS;

