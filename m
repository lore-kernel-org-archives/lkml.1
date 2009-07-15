Return-Path: <linux-kernel-owner+w=401wt.eu-S1756354AbZGOW7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756354AbZGOW7l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 18:59:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756070AbZGOW7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 18:59:41 -0400
Received: from yumi.tdiedrich.de ([85.10.210.183]:44777 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756050AbZGOW7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 18:59:39 -0400
Date: Thu, 16 Jul 2009 00:59:36 +0200
From: Tobias Diedrich <ranma+kernel@tdiedrich.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, Pavel Machek <pavel@ucw.cz>,
       kernel list <linux-kernel@vger.kernel.org>, ibm-acpi@hmh.eng.br,
       ibm-acpi-devel@lists.sourceforge.net
Subject: Re: 2.6.31-rc2: thinkpad boots with backlight low
Message-ID: <20090715225936.GA30370@yamamaya.is-a-geek.org>
Mail-Followup-To: Tobias Diedrich <ranma+kernel@tdiedrich.de>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Pavel Machek <pavel@ucw.cz>,
	kernel list <linux-kernel@vger.kernel.org>, ibm-acpi@hmh.eng.br,
	ibm-acpi-devel@lists.sourceforge.net
References: <20090714092513.GB2010@elf.ucw.cz> <20090715112204.GA16289@yamamaya.is-a-geek.org> <20090715143509.GC22098@khazad-dum.debian.net> <20090715223931.GA18924@yamamaya.is-a-geek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090715223931.GA18924@yamamaya.is-a-geek.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tobias Diedrich wrote:
> Henrique de Moraes Holschuh wrote:
> > There is one thing that comes to mind: display power management.
> > 
> > Is anything, by chance, setting the backlight devices to low power mode
> > on machine restart?  The backlight drivers would try to set brightness
> > to 0 when it cannot turn the display off for real...
> 
> Whatever registers /sys/class/backlight/thinkpad_screen/ seems to be
> responsible.
> After boot this has 0 for brightness and actual_brightness, 7 for
> max_brightness.
> Adjusting the backlight brightness with thinkpad keys does not
> affect this at all, it always stays at 0.
> If I manually change it to 7 and reboot (or poweroff, for
> that matter), then backlight brightness is apparently changed to
> that value (instead of minimum).
> 
> grepping shows it's actually thinkpad_acpi registering
> thinkpad_screen. (Well, that was kind of to be expected)
> And /proc/acpi/ibm/brightness also doesn't seem to reflect the real
> current value...
> 
> What irritates me is that a compiled in thinkpad_acpi does not show
> up as a module in /sys/modules and so I can't look at the
> module parameters. (brightness_mode looks interesting)

Ok, after compiling it as a module and trying a few variations, it
seems that on my X41 Tablet only brightness_mode=2 works, that is
TPACPI_BRGHT_MODE_UCMS_STEP.

This is contrasted by thinkpad_acpi.c which states:
|if (acpi_evalf(ec_handle, NULL, "HBRV", "qd"))
|	/* T40-T43, R50-R52, R50e, R51e, X31-X41 */
|	brightness_mode = TPACPI_BRGHT_MODE_ECNVRAM;
|else
|	/* all other IBM ThinkPads */
|	brightness_mode = TPACPI_BRGHT_MODE_UCMS_STEP;

So TPACPI_BRGHT_MODE_ECNVRAM looks broken somehow?
I assume that the autodetection finds the HBRV acpi function and
selects the former, resulting in a not working backlight control.

FWIW here is the dmi info on my model:

# dmidecode 2.9
SMBIOS 2.33 present.
59 structures occupying 1911 bytes.
Table at 0x000E0010.

Handle 0x0000, DMI type 0, 20 bytes
BIOS Information
	Vendor: IBM
	Version: 75ET60WW (2.06 )
	Release Date: 12/19/2006
	Address: 0xDC000
	Runtime Size: 144 kB
	ROM Size: 1024 kB
	Characteristics:
		PCI is supported
		PC Card (PCMCIA) is supported
		PNP is supported
		APM is supported
		BIOS is upgradeable
		BIOS shadowing is allowed
		ESCD support is available
		Boot from CD is supported
		Selectable boot is supported
		EDD is supported
		3.5"/720 KB floppy services are supported (int 13h)
		Print screen service is supported (int 5h)
		8042 keyboard services are supported (int 9h)
		Serial services are supported (int 14h)
		Printer services are supported (int 17h)
		CGA/mono video services are supported (int 10h)
		ACPI is supported
		USB legacy is supported
		BIOS boot specification is supported

Handle 0x0001, DMI type 1, 25 bytes
System Information
	Manufacturer: IBM
	Product Name: 1866CTO
	Version: ThinkPad X41 Tablet
	Serial Number: LVH5852
	UUID: AEDCB235-6567-8ADE-CC6E-DAC3BC6EDAC2
	Wake-up Type: Power Switch

Handle 0x0002, DMI type 2, 8 bytes
Base Board Information
	Manufacturer: IBM
	Product Name: 1866CTO
	Version: Not Available
	Serial Number: 3425458GFA4

Handle 0x0003, DMI type 3, 17 bytes
Chassis Information
	Manufacturer: IBM
	Type: Notebook
	Lock: Not Present
	Version: Not Available
	Serial Number: Not Available
	Asset Tag: No Asset Information
	Boot-up State: Unknown
	Power Supply State: Unknown
	Thermal State: Unknown
	Security Status: Unknown
	OEM Information: 0x00000000

Handle 0x0004, DMI type 126, 17 bytes
Inactive

Handle 0x0005, DMI type 126, 17 bytes
Inactive

Handle 0x0006, DMI type 4, 35 bytes
Processor Information
	Socket Designation: None
	Type: Central Processor
	Family: Pentium M
	Manufacturer: GenuineIntel
	ID: D8 06 00 00 FF FB E9 AF
	Signature: Type 0, Family 6, Model 13, Stepping 8
	Flags:
		FPU (Floating-point unit on-chip)
		VME (Virtual mode extension)
		DE (Debugging extension)
		PSE (Page size extension)
		TSC (Time stamp counter)
		MSR (Model specific registers)
		PAE (Physical address extension)
		MCE (Machine check exception)
		CX8 (CMPXCHG8 instruction supported)
		APIC (On-chip APIC hardware supported)
		SEP (Fast system call)
		MTRR (Memory type range registers)
		PGE (Page global enable)
		MCA (Machine check architecture)
		CMOV (Conditional move instruction supported)
		PAT (Page attribute table)
		CLFSH (CLFLUSH instruction supported)
		DS (Debug store)
		ACPI (ACPI supported)
		MMX (MMX technology supported)
		FXSR (Fast floating-point save and restore)
		SSE (Streaming SIMD extensions)
		SSE2 (Streaming SIMD extensions 2)
		SS (Self-snoop)
		TM (Thermal monitor supported)
		PBE (Pending break enabled)
	Version: Intel(R) Pentium(R) M processor
	Voltage: 1.1 V
	External Clock: 400 MHz
	Max Speed: 1500 MHz
	Current Speed: 1500 MHz
	Status: Populated, Enabled
	Upgrade: None
	L1 Cache Handle: 0x000A
	L2 Cache Handle: 0x000B
	L3 Cache Handle: Not Provided
	Serial Number: Not Specified
	Asset Tag: Not Specified
	Part Number: Not Specified

Handle 0x0007, DMI type 5, 20 bytes
Memory Controller Information
	Error Detecting Method: None
	Error Correcting Capabilities:
		None
	Supported Interleave: One-way Interleave
	Current Interleave: One-way Interleave
	Maximum Memory Module Size: 1024 MB
	Maximum Total Memory Size: 2048 MB
	Supported Speeds:
		Other
	Supported Memory Types:
		DIMM
		SDRAM
	Memory Module Voltage: 2.9 V
	Associated Memory Slots: 2
		0x0008
		0x0009
	Enabled Error Correcting Capabilities:
		Unknown

Handle 0x0008, DMI type 6, 12 bytes
Memory Module Information
	Socket Designation: DIMM Slot 1
	Bank Connections: 0 3
	Current Speed: Unknown
	Type: DIMM SDRAM
	Installed Size: 512 MB (Double-bank Connection)
	Enabled Size: 512 MB (Double-bank Connection)
	Error Status: OK

Handle 0x0009, DMI type 6, 12 bytes
Memory Module Information
	Socket Designation: DIMM Slot 2
	Bank Connections: 4 7
	Current Speed: Unknown
	Type: DIMM SDRAM
	Installed Size: 1024 MB (Double-bank Connection)
	Enabled Size: 1024 MB (Double-bank Connection)
	Error Status: OK

Handle 0x000A, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Internal L1 Cache
	Configuration: Enabled, Socketed, Level 1
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 32 KB
	Maximum Size: 32 KB
	Supported SRAM Types:
		Synchronous
	Installed SRAM Type: Synchronous
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Data
	Associativity: 8-way Set-associative

Handle 0x000B, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Internal L2 Cache
	Configuration: Enabled, Socketed, Level 2
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 2048 KB
	Maximum Size: 2048 KB
	Supported SRAM Types:
		Burst
	Installed SRAM Type: Burst
	Speed: Unknown
	Error Correction Type: Multi-bit ECC
	System Type: Unified
	Associativity: 8-way Set-associative

Handle 0x000C, DMI type 126, 9 bytes
Inactive

Handle 0x000D, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Available
	Internal Connector Type: None
	External Reference Designator: Infrared
	External Connector Type: Infrared
	Port Type: Other

Handle 0x000E, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Available
	Internal Connector Type: None
	External Reference Designator: Parallel
	External Connector Type: DB-25 female
	Port Type: Parallel Port ECP/EPP

Handle 0x000F, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Available
	Internal Connector Type: None
	External Reference Designator: External Monitor
	External Connector Type: DB-15 female
	Port Type: Video Port

Handle 0x0010, DMI type 126, 9 bytes
Inactive

Handle 0x0011, DMI type 126, 9 bytes
Inactive

Handle 0x0012, DMI type 126, 9 bytes
Inactive

Handle 0x0013, DMI type 126, 9 bytes
Inactive

Handle 0x0014, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Available
	Internal Connector Type: None
	External Reference Designator: Microphone Jack
	External Connector Type: Mini Jack (headphones)
	Port Type: Audio Port

Handle 0x0015, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Available
	Internal Connector Type: None
	External Reference Designator: Headphone Jack
	External Connector Type: Mini Jack (headphones)
	Port Type: Audio Port

Handle 0x0016, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Available
	Internal Connector Type: None
	External Reference Designator: Modem
	External Connector Type: RJ-11
	Port Type: Modem Port

Handle 0x0017, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Available
	Internal Connector Type: None
	External Reference Designator: Ethernet
	External Connector Type: RJ-45
	Port Type: Network Port

Handle 0x0018, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Available
	Internal Connector Type: None
	External Reference Designator: USB 1
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x0019, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Available
	Internal Connector Type: None
	External Reference Designator: USB 2
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x001A, DMI type 126, 9 bytes
Inactive

Handle 0x001B, DMI type 126, 9 bytes
Inactive

Handle 0x001C, DMI type 126, 9 bytes
Inactive

Handle 0x001D, DMI type 126, 9 bytes
Inactive

Handle 0x001E, DMI type 9, 13 bytes
System Slot Information
	Designation: CardBus Slot 1
	Type: 32-bit PC Card (PCMCIA)
	Current Usage: Available
	Length: Other
	ID: Adapter 0, Socket 0
	Characteristics:
		5.0 V is provided
		3.3 V is provided
		PC Card-16 is supported
		Cardbus is supported
		Zoom Video is supported
		Modem ring resume is supported
		PME signal is supported
		Hot-plug devices are supported

Handle 0x001F, DMI type 126, 13 bytes
Inactive

Handle 0x0020, DMI type 126, 13 bytes
Inactive

Handle 0x0021, DMI type 9, 13 bytes
System Slot Information
	Designation: SD Slot
	Type: 32-bit Other
	Current Usage: Available
	Length: Other
	Characteristics:
		5.0 V is provided
		3.3 V is provided
		PME signal is supported
		Hot-plug devices are supported

Handle 0x0022, DMI type 9, 13 bytes
System Slot Information
	Designation: Mini-PCI Slot 1
	Type: 32-bit PCI
	Current Usage: Available
	Length: Other
	ID: 1
	Characteristics:
		5.0 V is provided
		3.3 V is provided
		PME signal is supported
		SMBus signal is supported

Handle 0x0023, DMI type 126, 13 bytes
Inactive

Handle 0x0024, DMI type 10, 6 bytes
On Board Device Information
	Type: Other
	Status: Enabled
	Description: IBM Embedded Security hardware

Handle 0x0025, DMI type 11, 5 bytes
OEM Strings
	String 1: IBM ThinkPad Embedded Controller -[75HT20WW-1.02    ]-

Handle 0x0026, DMI type 13, 22 bytes
BIOS Language Information
	Installable Languages: 1
		enUS
	Currently Installed Language: enUS

Handle 0x0027, DMI type 15, 25 bytes
System Event Log
	Area Length: 0 bytes
	Header Start Offset: 0x0000
	Header Length: 16 bytes
	Data Start Offset: 0x0010
	Access Method: General-purpose non-volatile data functions
	Access Address: 0x0000
	Status: Invalid, Full
	Change Token: 0x00000059
	Header Format: Type 1
	Supported Log Type Descriptors: 1
	Descriptor 1: POST error
	Data Format 1: POST results bitmap

Handle 0x0028, DMI type 16, 15 bytes
Physical Memory Array
	Location: System Board Or Motherboard
	Use: System Memory
	Error Correction Type: None
	Maximum Capacity: 1 GB
	Error Information Handle: Not Provided
	Number Of Devices: 2

Handle 0x0029, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x0028
	Error Information Handle: No Error
	Total Width: 64 bits
	Data Width: 64 bits
	Size: 512 MB
	Form Factor: SODIMM
	Set: None
	Locator: DIMM 1
	Bank Locator: Bank 0/1
	Type: DDR
	Type Detail: Synchronous
	Speed: Unknown
	Manufacturer: Not Specified
	Serial Number: Not Specified
	Asset Tag: Not Specified
	Part Number: Not Specified

Handle 0x002A, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x0028
	Error Information Handle: No Error
	Total Width: 64 bits
	Data Width: 64 bits
	Size: 1024 MB
	Form Factor: SODIMM
	Set: None
	Locator: DIMM 2
	Bank Locator: Bank 2/3
	Type: DDR
	Type Detail: Synchronous
	Speed: Unknown
	Manufacturer: Not Specified
	Serial Number: Not Specified
	Asset Tag: Not Specified
	Part Number: Not Specified

Handle 0x002B, DMI type 18, 23 bytes
32-bit Memory Error Information
	Type: OK
	Granularity: Unknown
	Operation: Unknown
	Vendor Syndrome: Unknown
	Memory Array Address: Unknown
	Device Address: Unknown
	Resolution: Unknown

Handle 0x002C, DMI type 19, 15 bytes
Memory Array Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x0005FFFFFFF
	Range Size: 1536 MB
	Physical Array Handle: 0x0028
	Partition Width: 0

Handle 0x002D, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x0001FFFFFFF
	Range Size: 512 MB
	Physical Device Handle: 0x0029
	Memory Array Mapped Address Handle: 0x002C
	Partition Row Position: 1

Handle 0x002E, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00020000000
	Ending Address: 0x0005FFFFFFF
	Range Size: 1 GB
	Physical Device Handle: 0x002A
	Memory Array Mapped Address Handle: 0x002C
	Partition Row Position: 1

Handle 0x002F, DMI type 21, 7 bytes
Built-in Pointing Device
	Type: Track Point
	Interface: PS/2
	Buttons: 3

Handle 0x0030, DMI type 126, 7 bytes
Inactive

Handle 0x0031, DMI type 24, 5 bytes
Hardware Security
	Power-On Password Status: Disabled
	Keyboard Password Status: Disabled
	Administrator Password Status: Disabled
	Front Panel Reset Status: Unknown

Handle 0x0032, DMI type 32, 11 bytes
System Boot Information
	Status: No errors detected

Handle 0x0033, DMI type 131, 17 bytes
OEM-specific Type
	Header and Data:
		83 11 33 00 01 02 03 FF FF 1F 00 00 00 00 00 02
		00
	Strings:
		BOOTINF 20h
		BOOTDEV 21h
		KEYPTRS 23h

Handle 0x0034, DMI type 132, 7 bytes
OEM-specific Type
	Header and Data:
		84 07 34 00 01 D8 36

Handle 0x0035, DMI type 133, 5 bytes
OEM-specific Type
	Header and Data:
		85 05 35 00 01
	Strings:
		KHOIHGIUCCHHII

Handle 0x0036, DMI type 126, 13 bytes
Inactive

Handle 0x0037, DMI type 135, 13 bytes
OEM-specific Type
	Header and Data:
		87 0D 37 00 54 50 07 00 01 01 00 00 00

Handle 0x0038, DMI type 135, 18 bytes
OEM-specific Type
	Header and Data:
		87 12 38 00 54 50 07 01 01 9E 00 00 00 00 00 00
		00 00

Handle 0x0039, DMI type 136, 6 bytes
OEM-specific Type
	Header and Data:
		88 06 39 00 5A 5A

Handle 0x003A, DMI type 127, 4 bytes
End Of Table




-- 
Tobias						PGP: http://9ac7e0bc.uguu.de
